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
	#sets up custom signal for building system and wave skip
	for i in get_tree().get_nodes_in_group("build_button"):
		i.connect("pressed", self, "initiate_build_mode", [i.get_name()])
	for i in get_tree().get_nodes_in_group("skip_wave"):
		i.connect("pressed", self, "skip_wave")
	start_wave()
	GameStats.PlayerMoney = 100
	GameStats.PlayerLives = 5

func _unhandled_input(event):
	#runs build mode functions if in buildmode
	if event.is_action_released("right_click") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("left_click") and build_mode == true:
		verify_and_build()
		cancel_build_mode()

func _process(delta):
	#sets wave timer
	GameStats.time_till_next_wave = int(self.get_node("WaveCooldown").time_left)
	#updates building preview
	if build_mode:
		update_tower_preview()
	#print(GameStats.lvlwaves[self.name].size() - 1)
	#print(current_wave)
	#if current_wave < (GameStats.lvlwaves[self.name].size()):
	#	start_wave()
	#ends game when all eneemies are ded
	if (current_wave >= GameStats.lvlwaves[self.name].size() -1) and no_enemies_left():
		game_won()

func game_over():
	print("loser")
	get_tree().quit()

func game_won():
	print("winner")
	get_tree().quit()

####################################################################################################
##Wave Functions
####################################################################################################
func start_wave():
	#spawns wave
	var wave_data = retrieve_wave_data()
	yield(get_tree().create_timer(0.2),"timeout") #stops waves spawning instantly
	spawn_enemies(wave_data)
	GameStats.current_wave = current_wave
	self.get_node("WaveCooldown").wait_time = 0
	if current_wave != (GameStats.lvlwaves[self.name].size()):
		self.get_node("WaveCooldown").start()
	#print(GameStats.lvlwaves[self.name].size())

func skip_wave():
	#skips cooldown between waves giving player money equivelent to remaining money
	if current_wave < GameStats.lvlwaves[self.name].size() and no_enemies_left():
		start_wave()
		GameStats.PlayerMoney += int(self.get_node("WaveCooldown").time_left * 1)

func retrieve_wave_data():
	#retrieves wave data
	var wave_data = GameStats.lvlwaves[self.name]["wave"+str(current_wave)]#[["greyAPC", 0.7], ["greyAPC", 0.2]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data

func spawn_enemies(wave_data):
	#spawns enemies dependent on the wave data
	for i in wave_data:
		var new_enemy = load("res://Enemy/"+i[0]+".tscn").instance()
		get_node("Path2D").add_child(new_enemy, true)
		yield(get_tree().create_timer(i[1]),"timeout")

func _on_WaveCooldown_timeout():
	#starts next wave when wave cooldown ends
	if current_wave < GameStats.lvlwaves[self.name].size():
		start_wave()
	else:
		pass

func no_enemies_left() -> bool:
	#checks if enemys remain
	if self.get_node("Path2D").get_child_count() == 0:
		return true
	else:
		return false

####################################################################################################
##Building Functions
####################################################################################################
func initiate_build_mode(tower_type):
	#initiates build mode or cancels if player is poor
	if build_mode:
		cancel_build_mode()
	build_type = tower_type + "T1"
	build_mode = true
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())
	if GameStats.PlayerMoney < GameStats.tower_data[build_type]["cost"]:
		cancel_build_mode()

func update_tower_preview():
	#updates preview
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
	#sets build mode to false and ditches the preview
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").free()

func verify_and_build():
	#verifys wether the building can be built and if valid builds the building
	if build_valid:
		var new_tower = load("res://Towers/" + build_type + ".tscn").instance()
		new_tower.position = build_location
		new_tower.built = true
		new_tower.turret_type = build_type
		get_node("Towers").add_child(new_tower, true)
		get_node("TowerExclusion").set_cellv(build_tile, 5)
		GameStats.PlayerMoney -= GameStats.tower_data[build_type]["cost"]
