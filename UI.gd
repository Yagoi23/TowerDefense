extends Node

func _ready():
	pass

onready var moneydisplay = $MoneyBar/Label
onready var wavecounter = $WaveCounter/Label
onready var wavetimer = $WaveTimer/Value
onready var lifecounter = $LifeCounter/Label
onready var enemiesremaining = $EnemiesRemaining/Label


func _process(delta):
	moneydisplay.text = "$" + str(GameStats.PlayerMoney)
	wavecounter.text = str(GameStats.current_wave)
	wavetimer.text = str(GameStats.time_till_next_wave)
	lifecounter.text = str(GameStats.PlayerLives)
	enemiesremaining.text = str(self.get_parent().get_node("Path2D").get_child_count())

func set_tower_preview(tower_type, mouse_position):
	var drag_tower = load("res://Towers/" + tower_type + ".tscn").instance()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("ad54ff3c")
	
	var range_texture = Sprite.new()
	range_texture.position = Vector2(32, 32)
	var scaling = GameStats.tower_data[tower_type]["range"] / 600.0
	range_texture.scale = Vector2(scaling, scaling)
	var texture = load("res://Towers/range_overlay.png")
	range_texture.texture = texture
	range_texture.modulate = Color("ad54ff3c")
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(range_texture, true)
	control.rect_position = mouse_position
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(get_node("TowerPreview"), 0)

func update_tower_preview(tile_position, color):
	get_node("TowerPreview").rect_position = tile_position
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate = Color(color)
		get_node("TowerPreview/Sprite").modulate = Color(color)


func _on_PausePlay_pressed():
	if get_tree().is_paused():
		get_tree().paused = false
	else:
		get_tree().paused = true


func _on_SpeedUp_pressed():
	print("pushed")
	if Engine.get_time_scale() == 5.0:
		Engine.set_time_scale(1.0)
		print("1")
	else:
		print("2")
		Engine.set_time_scale(5.0)
	#if get_tree().is_paused():
	#	get_tree().paused = false
	print(Engine.time_scale)
