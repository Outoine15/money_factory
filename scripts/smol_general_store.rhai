//machine role: spend your money

import "voxel_eras/scripts/audio_source" as audio;
import "voxel_eras/scripts/player" as player;
import "voxel_eras/scripts/utils" as utils;

fn define(mod_info) {
	mod_info.add(TextureBuilder(
        "smolGeneralStoreTop:MoneyFactory",
        "money_factory/assets/textures/smol_general_storeTop.png",
    ));
	mod_info.add(TextureBuilder(
        "smolGeneralStoreSide:MoneyFactory",
        "money_factory/assets/textures/smol_general_store.png",
    ));
	mod_info.add(
		VoxelBuilder(
			"smolGeneralStore:MoneyFactory",
			"S.M.O.L General Store",
			"money_factory/scripts/smol_general_store.rhai"
		).model(SolidVoxelModel(
            "smolGeneralStoreTop:MoneyFactory", //top
            "smolGeneralStoreSide:MoneyFactory", //sides
            "smolGeneralStoreTop:MoneyFactory") //botom
		).pipette("smolGeneralStore:MoneyFactory")
		.break_rate(voxel::BREAK_RATE_MACHINE)
		.tag("Solid:VoxelEras")
		.does_break()
		.does_interact()
		.does_interacting()
		.does_action()
	);
	
	mod_info.add(
		ConstructBuilder(
			"smolGeneralStore:MoneyFactory",
			"S.M.O.L General Store",
			"Spend you Money to buy all the items you need.",
			"Machines",
			"smolGeneralStoreIcon:MoneyFactory",
			construct::ROT_NONE
		).variant(
			ConstructVariantBuilder(voxel::ROT_UP)
				.place(
					0, 0, 0,
					WeakVoxelVariant("smolGeneralStore:MoneyFactory", voxel::ROT_UP)
				)
		)
		.cost(WeakItemStack("ClockworkCore:VoxelEras",1))
		.cost(WeakItemStack("CarbonSteelPlate:VoxelEras",5))
		.cost(WeakItemStack("OakPlank:VoxelEras",1))
		.priority(0)
	);
}

fn on_break(voxel, location, target, entity, game_state) {
	if location == target {
		game_state.drop(WeakItemStack("ClockworkCore:VoxelEras",1),location);
		game_state.drop(WeakItemStack("CarbonSteelPlate:VoxelEras",5),location);
		game_state.drop(WeakItemStack("OakPlank:VoxelEras",1),location);
	}

	event::ACCEPT
}

fn on_interact(voxel, location, entity, game_state) {
	entity.start_interacting(location);

	audio::spawn_oneshot_3d(
		"WorkbenchInteract:VoxelEras",
		"Player:VoxelEras",
		Vec3(location.x.to_float() + 0.5, location.y.to_float() + 0.5, location.z.to_float() + 0.5),
		game_state,
		1.,
		10.
	);

	event::ACCEPT
}

fn on_interacting(voxel, location, entity, egui, client_state) {
	let game_state = client_state.game_state;
	egui.window(
		"smolGeneralStore",
		|ui| {
			client_state.heading(
				ui,
				"smolGeneralStoreIcon:MoneyFactory",
				"S.M.O.L General Store",
				"buy all the clockwork era items here!\nFor more advances material see the other S.M.O.L stores"
			);

			utils::instant_crafter_ui(
				location,
				ui,
				"smolGeneralStore:MoneyFactory",
				entity,
				client_state
			);

			player::inventory_ui(ui, entity, client_state);
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

fn on_action(voxel, location, player, type, message, game_state) {
	if type != "Craft" {
		return;
	}

	let entity = game_state.validate_player_interact(player, location);
	if entity == () { return; }

	utils::instant_crafter_action(
		message,
		"smolGeneralStore:MoneyFactory",
		entity,
		game_state
	);

	audio::spawn_oneshot_3d(
		"WorkbenchCraft:VoxelEras",
		"Player:VoxelEras",
		Vec3(location.x.to_float() + 0.5, location.y.to_float() + 0.5, location.z.to_float() + 0.5),
		game_state,
		1.,
		15.
	);

	()
} 