extends Turret

func _ready():
	$Turret/Position2D/MuzzleFlash.visible = false

var shot = false

func _process(delta):
	if not ready and shot == false:
		play_fire_animation()
		shot = true
	if ready:
		shot = false

func play_fire_animation():
	$AnimationPlayer.play("Fire")
