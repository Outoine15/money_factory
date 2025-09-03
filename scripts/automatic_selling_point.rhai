//machine role: make you money

import "voxel_eras/scripts/player" as player;

const REQUIRED_PROGRESS = game::TICK_RATE * 4;
const MAX_ENERGY = game::TICK_RATE / 2;

fn define(mod_info) {
	mod_info.add(TextureBuilder(
        "default:MoneyFactory",
        "money_factory/assets/default.png",
    ));
		//TODO: done down to here the rest to do
	mod_info.add(
		VoxelBuilder(
			"manualBuyerOff:MoneyFactory",
			"manual Buyer (Off)",
			"alloy_dusts/scripts/mixer.rhai"
		).model(
			SolidVoxelModel(
			"voxel_eras/assets/textures/AlloyFurnaceTop.png",
			"alloy_dusts/assets/MixerSide.png",
			"voxel_eras/assets/textures/AlloyFurnaceBottom.png"
		))
		.pipette("Mixer:AlloyDusts")
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
			"MixerOn:AlloyDusts",
			"Mixer (On)",
			"alloy_dusts/scripts/mixer.rhai"
		).model(
			SolidVoxelModel(
			"voxel_eras/assets/textures/AlloyFurnaceTop.png",
			"alloy_dusts/assets/MixerOnAnim.png",
			"voxel_eras/assets/textures/AlloyFurnaceBottom.png"
		))
		.pipette("Mixer:AlloyDusts")
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
			"Mixer:AlloyDusts",
			"Mixer",
			"Mix and Match! Use the power of clockwork to automatically mix dusts together.",
			"Machines",
			"MixerIcon:AlloyDusts",
			construct::ROT_NONE
		).cost(WeakItemStack("ClockworkCore:VoxelEras", 1))
		.cost(WeakItemStack("CarbonSteelTube:VoxelEras", 3))
		.cost(WeakItemStack("CarbonSteelGear:VoxelEras", 2))
        .cost(WeakItemStack("CarbonSteelPlate:VoxelEras", 4))
		.variant(
			ConstructVariantBuilder(voxel::ROT_UP)
				.place(
					0, 0, 0,
					WeakVoxelVariant("MixerOff:AlloyDusts", voxel::ROT_UP)
					.add_state("State:Inventory", metadata::Inventory(3))
					.add_state("State:ClockworkEnergy", metadata::U64(0))
					.add_state("State:Progress", metadata::U64(0))
				)
		).priority(9)
	);
	
	mod_info.add(
		RecipeBuilder(
			"CarbonSteelDustMixer:AlloyDusts",
			"Mix Coal Dust and Iron Dust into Carbon Steel Dust",
			0,
			"SteelDustIcon:AlloyDusts"
		).crafted_in("Mixer:AlloyDusts")
        .with_input(WeakItemStack("IronDust:AlloyDusts", 2))
		.with_input(WeakItemStack("CoalDust:VoxelEras", 4))
		.with_output(WeakItemStack("SteelDust:AlloyDusts", 2))
	);
	mod_info.add(
		RecipeBuilder(
			"BronzeDustMixer:AlloyDusts",
			"Mix Copper Dust and Tin Dust into Bronze Dust",
			0,
			"SteelDustIcon:AlloyDusts"
		).crafted_in("Mixer:AlloyDusts")
        .with_input(WeakItemStack("CopperDust:AlloyDusts", 3))
		.with_input(WeakItemStack("TinDust:AlloyDusts", 1))
		.with_output(WeakItemStack("BronzeDust:AlloyDusts", 4))
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
		
		game_state.drop(WeakItemStack("ClockworkCore:VoxelEras", 1), location);
		game_state.drop(WeakItemStack("CarbonSteelGear:VoxelEras", 2), location);
		game_state.drop(WeakItemStack("CarbonSteelTube:VoxelEras", 3), location);
        game_state.drop(WeakItemStack("CarbonSteelPlate:VoxelEras", 4), location);
	}

	event::ACCEPT
}

fn on_interact(voxel, location, entity, game_state) {
	entity.start_interacting(location);

	event::ACCEPT
}

fn on_insert(voxel, location, slot, stack, direction, game_state) {
	if slot == 0 && (stack.item.identifier == "IronDust:AlloyDusts" || stack.item.identifier == "CopperDust:AlloyDusts") {
		event::ACCEPT
    } else if slot == 1 && (stack.item.identifier == "CoalDust:VoxelEras" || stack.item.identifier == "TinDust:AlloyDusts") {
        event::ACCEPT
	} else {
		event::CANCEL
	}
}

fn on_extract(voxel, location, slot, items, direction, game_state) {
	if direction != () && slot != 2 {
		return event::CANCEL;
	}

	event::ACCEPT
}

fn on_tick(voxel, location, game_state) {
	let metadata = voxel.metadata;

	let energy = metadata.get_u64("State:ClockworkEnergy");
	let progress = metadata.get_u64("State:Progress");
	let inventory = metadata.get_inventory();
	
	let recipe = game_state.find_possible_recipe("Mixer:AlloyDusts", [inventory[0], inventory[1]], [inventory[2]]);

	if energy == 0 {
		if recipe != () {
			if progress > 0 {
				progress -= 1;
				metadata.set_u64("State:Progress", progress);
			} else if voxel.prefab.identifier == "MixerOff:AlloyDusts" {
				return event::ACCEPT;
			}
		} else if voxel.prefab.identifier == "MixerOff:AlloyDusts" {
			return event::ACCEPT;
		}
	}

	if energy > 0 {
		let was_running = false;
		if recipe != () {
			was_running = true;
			energy -= 1;
			metadata.set_u64("State:ClockworkEnergy", energy);

			progress += 1;

			// Craft
			if progress >= global::REQUIRED_PROGRESS {
				if inventory[0].item == recipe.inputs[0].item {
					inventory[0].quantity -= recipe.inputs[0].quantity;
					inventory[1].quantity -= recipe.inputs[1].quantity;
				} else {
					inventory[1].quantity -= recipe.inputs[0].quantity;
					inventory[0].quantity -= recipe.inputs[1].quantity;
				}

				if inventory[2] == () {
					inventory[2] = recipe.outputs[0];
				} else {
					inventory[2].quantity += recipe.outputs[0].quantity;
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
					"MixerOn:AlloyDusts"
				} else {
					"MixerOff:AlloyDusts"
				})
				.get_variant(metadata));
	} else {
		game_state.set_voxel(location, 
			game_state
				.get_voxel_prefab("MixerOff:AlloyDusts")
				.get_variant(metadata));
	}

	event::ACCEPT
}

fn on_interacting(voxel, location, entity, egui, client_state) {
	let game_state = client_state.game_state;
	egui.window(
		"MixerInteracting",
		|ui| {
			client_state.heading(
				ui,
				"MixerIcon:AlloyDusts",
				"Mixer",
				"Give yourself a well earned break from manually mixing your dusts! Pipes can insert and extract from all directions."
			);

			mixer_ui(ui, location, voxel, entity, client_state);

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

private fn mixer_ui(ui, location, voxel, entity, client_state) {
	ui.vertical_centered_justified(|ui| {
		ui.set_width(200.);

		ui.horizontal(|ui| {
			mixer_interactables(ui, location, voxel, entity, client_state);
		});
	});
}

private fn mixer_interactables(ui, location, voxel, entity, client_state) {
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
        "DustOutputIcon:VoxelEras",
        "Insert either Iron Dust or Copper Dust into this slot.\nCan be input into from any side."
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


    let slot_interact = client_state.inventory_slot(
        ui,
        inventory[1],
        if selected_slot != () {
            selected_slot.inventory_index == 1 && selected_slot.slot_index == 1
        } else {
            false
        },
        "DustOutputIcon:VoxelEras",
        "Insert either Iron Dust or Copper Dust into this slot.\nCan be input into from any side."
    );

    if slot_interact.clicked() || slot_interact.secondary_clicked() {
        let metadata = MetaData();
        metadata.set_slot_ref("State:ClickedSlot", metadata::SlotRef(
            1,
            1,
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
        inventory[2],
        if selected_slot != () {
            selected_slot.inventory_index == 1 && selected_slot.slot_index == 2
        } else {
            false
        },
        "DustOutputIcon:VoxelEras",
        "The output of the Mixer.\nCan be taken from all sides."
    );
    if slot_interact.clicked_down() || slot_interact.secondary_clicked() {
        let metadata = MetaData();
        metadata.set_slot_ref("State:ClickedSlot", metadata::SlotRef(
            1,
            2,
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