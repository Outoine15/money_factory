//machine role: make you money

import "voxel_eras/scripts/player" as player;

const REQUIRED_PROGRESS = game::TICK_RATE * 4;
const MAX_ENERGY = game::TICK_RATE / 2;

fn define(mod_info) {
	mod_info.add(TextureBuilder(
        "default:MoneyFactory",
        "money_factory/assets/default.png",
    ));
	mod_info.add(
		VoxelBuilder(
			"autoSellPointOff:MoneyFactory",
			"automatic selling point (Off)",
			"money_factory/scripts/automatic_selling_point.rhai"
		).model(
			SolidVoxelModel(
            "voxel_eras/assets/textures/AlloyFurnaceTop.png", //top
            "money_factory/assets/textures/autoSellPointOff.png", //sides
            "voxel_eras/assets/textures/AlloyFurnaceBottom.png") //botom
		)
		.pipette("autoSellPoint:MoneyFactory")
		.break_rate(voxel::BREAK_RATE_MACHINE)
		.tag("Solid:VoxelEras")
		.does_break()
		.does_tick()
		.does_interact()
		.does_interacting()
		.does_insert()
		.does_extract()
		.does_action()
		.does_message()
	);

	mod_info.add(
		VoxelBuilder(
			"autoSellPointOn:MoneyFactory",
			"automatic selling point (On)",
			"money_factory/scripts/automatic_selling_point.rhai"
		).model(
			SolidVoxelModel(
            "voxel_eras/assets/textures/AlloyFurnaceTop.png", //top
            "money_factory/assets/textures/autoSellPointOnAnim.png", //sides
            "voxel_eras/assets/textures/AlloyFurnaceBottom.png") //botom
		)
		.pipette("autoSellPoint:MoneyFactory")
		.break_rate(voxel::BREAK_RATE_MACHINE)
		.tag("Solid:VoxelEras")
		.does_break()
		.does_tick()
		.does_interact()
		.does_interacting()
		.does_insert()
		.does_extract()
		.does_action()
		.does_message()
	);

	mod_info.add(
		ConstructBuilder(
			"autoSellPoint:MoneyFactory",
			"automatic selling point",
			"automaticaly sell any items put inside",
			"Machines",
			"autoSellPointIcon:MoneyFactory",
			construct::ROT_NONE
		)
		.cost(WeakItemStack("ClockworkCore:VOxelEras",1))
		.cost(WeakItemStack("CarbonSteelTube:VoxelEras", 3))
		.cost(WeakItemStack("CarbonSteelGear:VoxelEras", 2))
        .cost(WeakItemStack("CarbonSteelPlate:VoxelEras", 4)))
		.variant(
			ConstructVariantBuilder(voxel::ROT_UP)
				.place(
					0, 0, 0,
					WeakVoxelVariant("autoSellPointOff:MoneyFactory", voxel::ROT_UP)
					.add_state("State:Inventory", metadata::Inventory(3))
					.add_state("State:ClockworkEnergy", metadata::U64(0))
					.add_state("State:Progress", metadata::U64(0))
				)
		).priority(9)
	);

}

fn on_break(voxel, location, target, entity, game_state) {
	if location == target {
		let inventory = voxel.metadata.get_inventory();
		for slot in inventory {
			if slot == () {
				continue;
			}

			game_state.drop(slot, location);
		}
		
		game_state.drop(WeakItemStack("ClockworkCore:VOxelEras",1),location);
		game_state.drop(WeakItemStack("CarbonSteelTube:VoxelEras", 3),location);
		game_state.drop(WeakItemStack("CarbonSteelGear:VoxelEras", 2),location);
        game_state.drop(WeakItemStack("CarbonSteelPlate:VoxelEras", 4),location);
	}

	event::ACCEPT
}

fn on_interact(voxel, location, entity, game_state) {
	entity.start_interacting(location);

	event::ACCEPT
}

fn on_insert(voxel, location, slot, stack, direction, game_state) {
	event::ACCEPT
}

fn on_extract(voxel, location, slot, items, direction, game_state) {
	if direction != () && slot != 2 {
		return event::CANCEL;
	}

	event::ACCEPT
}

fn on_tick(voxel, location, game_state) {
	let metadata = voxel.metadata;

	let progress = metadata.get_u64("State:Progress");
	let inventory = metadata.get_inventory();
	
	let recipe = game_state.find_possible_recipe("autoSellPoint:MoneyFactory", [inventory[0]], [inventory[1]]);

	let was_running = false;
	if recipe != () {
		was_running = true;

		progress += 1;

		if progress >= global::REQUIRED_PROGRESS {
			if inventory[0].item == recipe.inputs[0].item {
				inventory[0].quantity -= recipe.inputs[0].quantity;
			}

			if inventory[1] == () {
				inventory[1] = recipe.outputs[0];
			} else {
				inventory[1].quantity += recipe.outputs[0].quantity;
			}

			metadata.set_inventory(inventory);
			progress = 0;
		}
		} else if progress > 0 {
			progress -= 1;
		}

		metadata.set_u64("State:Progress", progress);

		game_state.set_voxel(location,
			game_state.get_voxel_prefab(
				if was_running { 
					"autoSellPointOn:MoneyFactory"
				} else {
					"autoSellPointOff:MoneyFactory"
				})
				.get_variant(metadata));
	event::ACCEPT
}

fn on_interacting(voxel, location, entity, egui, client_state) {
	let game_state = client_state.game_state;
	egui.window(
		"autoSellPointInteracting",
		|ui| {
			client_state.heading(
				ui,
				"autoSellPointIcon:MoneyFactory",
				"automatic selling point",
				"just sell all that trash cloging up your inventory! Pipes can insert and extract from all directions."
			);

			autoSellPoint_ui(ui, location, voxel, entity, client_state);

			player::inventory_ui(
				ui,
				location,
				voxel,
				entity,
				client_state
			);
		}
	);

	let selected_slot = entity.metadata.get_slot_ref("State:SelectedSlot");
	if selected_slot != () {
		client_state.render_grabbed_slot(
			egui,
			selected_slot.using_primary, 
			(if selected_slot.inventory_index == 0 {
				entity.metadata.get_inventory()
			} else {
				game_state.get_voxel(location).metadata.get_inventory()
			})[selected_slot.slot_index]
		);
	}

	event::ACCEPT
}

fn on_message(voxel, location, type, message, game_state) {
	if type != "CLOCKWORK" { return event::CANCEL; }
	let energy = message;

	let stored_energy = voxel.metadata.get_u64("State:ClockworkEnergy");
	if stored_energy + energy > global::MAX_ENERGY {
		return event::CANCEL;
	}

	let new_state = voxel.metadata;
	new_state.set_u64("State:ClockworkEnergy", stored_energy + energy);

	game_state.set_voxel(
		location,
		voxel.get_variant(new_state)
	);

	event::ACCEPT
}

private fn autoSellPoint_ui(ui, location, voxel, entity, client_state) {
	ui.vertical_centered_justified(|ui| {
		ui.set_width(200.);

		ui.horizontal(|ui| {
			autoSellPoint_interactables(ui, location, voxel, entity, client_state);
		});
	});
}

private fn autoSellPoint_interactables(ui, location, voxel, entity, client_state) {
	const FIRE_FRAMES = 8;
	const COOK_FRAMES = 15;

	let metadata = voxel.metadata;
	let inventory = metadata.get_inventory();
	let selected_slot = entity.metadata.get_slot_ref("State:SelectedSlot");

	let cook_anim = ((metadata.get_u64("State:Progress") * COOK_FRAMES) / global::REQUIRED_PROGRESS).min(COOK_FRAMES - 1);


    let slot_interact = client_state.inventory_slot(
        ui,
        inventory[0],
        if selected_slot != () {
            selected_slot.inventory_index == 1 && selected_slot.slot_index == 0
        } else {
            false
        },
        "moneyOutputIcon:MoneyFactory",
        "Put any stufs you don't need in this slot to get paid.\nCan be input into from any side."
    );

    if slot_interact.clicked() || slot_interact.secondary_clicked() {
        let metadata = MetaData();
        metadata.set_slot_ref("State:ClickedSlot", metadata::SlotRef(
            1,
            0,
            slot_interact.clicked(),
			slot_interact.shifting()
        ));
        client_state.action(location, "Transfer", metadata);
    }

    client_state.draw_icon(
        ui,
        "CookingArrow" + cook_anim + "Icon:VoxelEras",
        Vec2(50., 50.)
    );


    let slot_interact = client_state.inventory_slot(
        ui,
        inventory[1],
        if selected_slot != () {
            selected_slot.inventory_index == 1 && selected_slot.slot_index == 1
        } else {
            false
        },
        "moneyOutputIcon:MoneyFactory",
        "The output of the Automatic Selling Point.\nCan be taken from all sides."
    );
    if slot_interact.clicked_down() || slot_interact.secondary_clicked() {
        let metadata = MetaData();
        metadata.set_slot_ref("State:ClickedSlot", metadata::SlotRef(
            1,
            1,
            slot_interact.clicked_down(),
			slot_interact.shifting()
        ));
        client_state.action(location, "Transfer", metadata);
    }
}

fn on_action(voxel, location, player, type, message, game_state) {
	if type != "Transfer" {
		return event::ACCEPT;
	}

	let player = game_state.validate_player_interact(player, location);
	if player == () { return event::ACCEPT; }

	let clicked_slot = message.get_slot_ref("State:ClickedSlot");
	if clicked_slot != () {
		game_state.voxel_entity_transfer(
			clicked_slot,
			location,
			voxel,
			player
		);
	}

	event::ACCEPT
} 