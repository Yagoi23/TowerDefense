extends KinematicBody2D
class_name BasicMissile

var target
var ammo_type
var proj_speed
var damage
var friendly_damage

func _physics_process(delta):
	move(delta)
	#this doesn't work yet #if get_node("Path2D").get_child_count() == 0:
		#this doesn't work yet #blow_up()
	#print(target + ammo_type + velocity)

func move(delta):
	#sets  the direction to the target and then moves towards the target
	if is_instance_valid(target):
		var tar_dir = global_position.direction_to(target.global_position)
		move_and_slide(tar_dir*proj_speed*delta)
		#points towards target
		look_at(target.global_position)
	else:
		blow_up()
	

func _on_Area2D_body_entered(body):
	#blows up when contacting a missile or enemy
	if body.is_in_group("enemy"):
		blow_up()
	if body.is_in_group("missile"):
		blow_up()

func blow_up():
	#creates a new explosiion and sets damage position and friendly damage
	var new_explosion = load("res://Explosion.tscn").instance()
	new_explosion.position = self.get_node("Position2D").global_position
	new_explosion.damage = damage
	new_explosion.friendly_damage = friendly_damage
	get_parent().add_child(new_explosion)
	#deletes this node
	self.queue_free()
