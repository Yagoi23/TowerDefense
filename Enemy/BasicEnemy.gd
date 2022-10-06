extends PathFollow2D
class_name BasicEnemy

var enemy_type = "greyAPC"

var speed = GameStats.enemy_data[enemy_type]["speed"]

func _physics_process(delta):
	move(delta)

func move(delta):
	set_offset(get_offset() + speed + delta)
