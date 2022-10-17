extends PathFollow2D
class_name BasicEnemy

var enemy_type = "greyAPC"

onready var healthbar = self.get_node("HealthBar")

var speed = GameStats.enemy_data[enemy_type]["speed"]
var health = GameStats.enemy_data[enemy_type]["health"]

func _ready():
	healthbar.max_value = health
	healthbar.value = health
	healthbar.set_as_toplevel(true)

func _physics_process(delta):
	if unit_offset == 1.0:
		GameStats.PlayerLives -= 1
		queue_free()
	move(delta)

func move(delta):
	set_offset(get_offset() + speed * delta)
	healthbar.set_position(self.position - Vector2(15,20))

func on_hit(damage):
	health -= damage
	if health <= 0:
		on_destroy()
	else:
		healthbar.value = health

func on_destroy():
	self.queue_free()
	GameStats.PlayerMoney += GameStats.enemy_data[enemy_type]["reward"]
