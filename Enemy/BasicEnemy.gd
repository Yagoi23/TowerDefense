extends PathFollow2D
class_name BasicEnemy

var enemy_type = "greyAPC"

onready var healthbar = self.get_node("HealthBar")

var speed = GameStats.enemy_data[enemy_type]["speed"]
var health = GameStats.enemy_data[enemy_type]["health"]

func _ready():
	#sets health and detaches healthbar from node
	healthbar.max_value = health
	healthbar.value = health
	healthbar.set_as_toplevel(true)

func _physics_process(delta):
	#deletes unit if at the end of the road or continues moving
	if unit_offset == 1.0:
		GameStats.PlayerLives -= 1
		queue_free()
	move(delta)

func move(delta):
	#increases offset -> distance along the path by speed
	set_offset(get_offset() + speed * delta)
	healthbar.set_position(self.position - Vector2(15,20))

func on_hit(damage):
	#decreases health then either gets destroyed or updates health bar
	health -= damage
	if health <= 0:
		on_destroy()
	else:
		healthbar.value = health

func on_destroy():
	#deletes node when dead
	self.queue_free()
	GameStats.PlayerMoney += GameStats.enemy_data[enemy_type]["reward"]
