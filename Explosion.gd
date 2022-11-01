extends Node2D

var size = 1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sprite = $Sprite
onready var blast_radius = $Area2D/CollisionShape2D

var damage
var friendly_damage

#var inside_blast_radius = []
# Called when the node enters the scene tree for the first time.
func _ready():
	#scales size and area based on blast inherited size
	blast_radius.shape.radius = 32*size
	sprite.scale = Vector2(size,size)
	$AnimationPlayer.play("Explosion")
	yield(get_tree().create_timer(0.25),"timeout")
	self.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	yield(get_tree().create_timer(0.25),"timeout")
#	self.queue_free()


func _on_Area2D_body_entered(body):
	#hits all enemies in the node
	if body.is_in_group("enemy"):
		#inside_blast_radius.append(body)
		body.get_parent().on_hit(damage)
		


func _on_Area2D_body_exited(body):
	pass
	#if body.is_in_group("enemy"):
		#inside_blast_radius.erase(body)
