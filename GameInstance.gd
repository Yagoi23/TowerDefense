extends Node2D
class_name GameInstance

var build_type
var build_location
var build_valid = false
var build_mode = false

var build_tile

var current_wave = 0
var enemies_in_wave = 0

func _ready():
	for i in get_tree().get_nodes_in_group("build_button"):
		i.connect("pressed", self, "initiate_build_mode", [i.get_name()])
	start_wave()

func _unhandled_input(event):
	if event.is_action_released("right_click") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("left_click") and build_mode == true:
		verify_and_build()
		cancel_build_mode()

func _process(delta):
	if build_mode:
		update_tower_preview()

####################################################################################################
##Wave Functions
####################################################################################################
func start_wave():
	var wave_data = retrieve_wave_data()
	yield(get_tree().create_timer(0.2),"timeout") #stops waves spawning instantly
	spawn_enemies(wave_data)

func retrieve_wave_data():
	var wave_data = [["greyAPC", 0.7], ["greyAPC", 0.2]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data

func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy = load("res://Enemy/"+i[0]+".tscn").instance()
		get_node("Path2D").add_child(new_enemy, true)
		yield(get_tree().create_timer(i[1]),"timeout")

####################################################################################################
##Building Functions
####################################################################################################
func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	build_type = tower_type + "T1"
	build_mode = true
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var current_tile = get_node("TowerExclusion").world_to_map(mouse_position)
	var tile_position = get_node("TowerExclusion").map_to_world(current_tile)
	
	if get_node("TowerExclusion").get_cellv(current_tile) == -1:
		get_node("UI").update_tower_preview(tile_position, "ad54ff3c")
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		get_node("UI").update_tower_preview(tile_position, "adff4545")
		build_valid = false

func cancel_build_mode():
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").free()

func verify_and_build():
	if build_valid:
		var new_tower = load("res://Towers/" + build_type + ".tscn").instance()
		new_tower.position = build_location
		get_node("Towers").add_child(new_tower, true)
		get_node("TowerExclusion").set_cellv(build_tile, 5)
