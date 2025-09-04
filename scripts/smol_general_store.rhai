//machine role: spend your money

import "voxel_eras/scripts/audio_source" as audio;
import "voxel_eras/scripts/player" as player;
import "voxel_eras/scripts/utils" as utils;

fn define(mod_info) {
	mod_info.add(TextureBuilder(
		"smolGeneralStoreIcon:MoneyFactory",
		"money_factory/assets/default.png"
	));

    // see if i remove/replace the sound at some point
	// mod_info.add(SoundBuilder(
	// 	"WorkbenchInteract:VoxelEras",
	// 	"Workbench Movement",
	// 	"voxel_eras/assets/sounds/WorkbenchMotion.mp3"
	// ));

	// mod_info.add(SoundBuilder(
	// 	"WorkbenchCraft:VoxelEras",
	// 	"Workbench Hit",
	// 	"voxel_eras/assets/sounds/WorkbenchHit.mp3"
	// ));


	mod_info.add(
		VoxelBuilder(
			"smolGeneralStore:MoneyFactory",
			"S.M.O.L General Store",
			"money_factory/scripts/smol_general_store.rhai"
		).model(SolidVoxelModel(
            "money_factory/assets/default.png", //top
            "money_factory/assets/default.png", //sides
            "money_factory/assets/default.png") //botom
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
		.cost(WeakItemStack("OakLog:VoxelEras", 4)) //TODO: change build cost on final build
		.priority(0)
	);

	mod_info.add(
		RecipeBuilder(
			"smolGeneralStore:MoneyFactory", //recepie name:mod/source ?
			"buy oak planks", 
			0, //position of the recepie on the grid?
			"OakPlankIcon:VoxelEras"
		).crafted_in("smolGeneralStore:MoneyFactory")
		.with_input(WeakItemStack("Money:MoneyFactory", 2))
		.with_output(WeakItemStack("OakPlank:VoxelEras", 1))
	);

    //other craft items:
	// mod_info.add(
	// 	RecipeBuilder(
	// 		"StickWorkbench:VoxelEras",
	// 		"Cut Oak Plank into Sticks",
	// 		1,
	// 		"StickIcon:VoxelEras",
	// 	).crafted_in("BasicWorkbench:VoxelEras")
	// 	.with_input(WeakItemStack("OakPlank:VoxelEras", 2))
	// 	.with_output(WeakItemStack("Stick:VoxelEras", 4))
	// );

	// mod_info.add(
	// 	RecipeBuilder(
	// 		"WoodenGearWorkbench:VoxelEras",
	// 		"Craft Wooden Gear",
	// 		2,
	// 		"WoodenGearIcon:VoxelEras",
	// 	).crafted_in("BasicWorkbench:VoxelEras")
	// 	.with_input(WeakItemStack("OakPlank:VoxelEras", 4))
	// 	.with_input(WeakItemStack("Stick:VoxelEras", 4))
	// 	.with_output(WeakItemStack("WoodenGear:VoxelEras", 2))
	// );

	// mod_info.add(
	// 	RecipeBuilder(
	// 		"PlantFiberWorkbench:VoxelEras",
	// 		"Weave Trimmings into Fiber",
	// 		4,
	// 		"PlantFiberIcon:VoxelEras"
	// 	).crafted_in("BasicWorkbench:VoxelEras")
	// 	.with_input(WeakItemStack("GrassTrimmings:VoxelEras", 4))
	// 	.with_output(WeakItemStack("PlantFiber:VoxelEras", 2))
	// );

	// mod_info.add(
	// 	RecipeBuilder(
	// 		"PlantFiberLeavesWorkbench:VoxelEras",
	// 		"Weave Oak Leaves into Fiber",
	// 		4,
	// 		"PlantFiberIcon:VoxelEras"
	// 	).crafted_in("BasicWorkbench:VoxelEras")
	// 	.with_input(WeakItemStack("OakLeaves:VoxelEras", 4))
	// 	.with_output(WeakItemStack("PlantFiber:VoxelEras", 2))
	// );
}

fn on_break(voxel, location, target, entity, game_state) {
	if location == target {
		game_state.drop(WeakItemStack("Dirt:VoxelEras", 1), location);//TODO: change cost acording to chaned build cost of final build
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