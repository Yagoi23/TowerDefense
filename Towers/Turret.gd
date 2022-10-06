extends Node2D
class_name Turret

func _ready():
	pass

func _physics_process(delta):
	turn()

func turn():
	var closest_enemy_position = get_global_mouse_position()
	get_node("Turret").look_at(closest_enemy_position)

