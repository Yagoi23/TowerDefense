extends Node2D
class_name Turret

var enemy_array = []
var built = false
var target_enemy = null
var turret_type
var ready = true

func _ready():
	if built:
		self.get_node("Range/CollisionShape2D").shape.radius = GameStats.tower_data[turret_type]["range"]/2

func _physics_process(delta):
	if enemy_array.size() >= 1 and built:
		select_enemy()
		turn()
		if ready:
			fire()
	else:
		target_enemy = null

func turn():
	#var closest_enemy_position = get_global_mouse_position()
	
	get_node("Turret").look_at(target_enemy.position)

func _on_Range_body_entered(body):
	enemy_array.append(body.get_parent())
	#print(enemy_array)

func _on_Range_body_exited(body):
	enemy_array.erase(body.get_parent())

func select_enemy():
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.offset)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	target_enemy = enemy_array[enemy_index]

func fire():
	ready = false
	target_enemy.on_hit(GameStats.tower_data[turret_type]["damage"])
	yield(get_tree().create_timer((GameStats.tower_data[turret_type]["fire_rate"])/GameStats.fire_rate_multiplier), "timeout")
	ready = true

