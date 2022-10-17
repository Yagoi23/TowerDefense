extends KinematicBody2D
class_name BasicMissile
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var target
var ammo_type
var proj_speed
var damage
var friendly_damage

func _physics_process(delta):
	move(delta)
	#print(target + ammo_type + velocity)

func move(delta):
	var velocity = global_position.direction_to(target.global_position)
	move_and_slide(velocity*proj_speed*delta)
	look_at(target.global_position)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		blow_up()
	if body.is_in_group("missile"):
		blow_up()

func blow_up():
	var new_explosion = load("res://Explosion.tscn").instance()
	new_explosion.position = self.get_node("Position2D").global_position
	new_explosion.damage = damage
	new_explosion.friendly_damage = friendly_damage
	#new_projectile.proj_speed = GameStats.tower_data[turret_type]["velocity"]
	#new_projectile.ammo_type = ammo_type
	#new_projectile.target = target_enemy
	#new_projectile.damage = GameStats.tower_data[turret_type]["damage"]
	#new_projectile.friendly_damage = GameStats.tower_data[turret_type]["friendly_damage"]
	get_parent().add_child(new_explosion)
	self.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
