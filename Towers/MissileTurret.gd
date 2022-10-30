extends Node2D
class_name MissileTurret

var enemy_array = []
var built = false
var target_enemy = null
var turret_type
var ready = true

func _ready():
	#sets range if turret is built
	if built:
		self.get_node("Range/CollisionShape2D").shape.radius = GameStats.tower_data[turret_type]["range"]/2

func _physics_process(delta):
	#print(enemy_array)
	#selects enemy turns to enemy and fires if ready
	if enemy_array.size() >= 1 and built:
		select_enemy()
		turn()
		if ready:
			fire()
			print(target_enemy)
	else:
		target_enemy = null
	#check_enemy_array()

func check_enemy_array():
	#checks if there is an enemy in the array
	for i in enemy_array:
		if not self.get_parent().get_node(enemy_array[i].name):
			enemy_array[i].erase()

func turn():
	#var closest_enemy_position = get_global_mouse_position()
	#turns towards the enemy
	get_node("Turret").look_at(target_enemy.position)

func _on_Range_body_entered(body):
	#adds enemy to array when the enter range
	enemy_array.append(body.get_parent())
	#print(enemy_array)

func _on_Range_body_exited(body):
	#removes enemy from array when they exit range
	enemy_array.erase(body.get_parent())

func select_enemy():
	#selects enemy closest to the end as the target enemy
	#var enemy_progress_array = []
	#for i in enemy_array:
	#	enemy_progress_array.append(i.offset)
	#var max_offset = enemy_progress_array.max()
	#var enemy_index = enemy_progress_array.find(max_offset)
	
	#fix to missile targeting bug
	target_enemy = enemy_array[0]#enemy_array[0]

func fire():
	#fires and assigns stats to the missile
	ready = false
	var ammo_type = GameStats.tower_data[turret_type]["projectile"]
	var new_projectile = load("res://Towers/" + ammo_type + ".tscn").instance()
	new_projectile.position = self.get_node("Turret/Position2D").global_position
	new_projectile.proj_speed = GameStats.tower_data[turret_type]["velocity"]
	new_projectile.ammo_type = ammo_type
	new_projectile.target = target_enemy
	new_projectile.damage = GameStats.tower_data[turret_type]["damage"]
	new_projectile.friendly_damage = GameStats.tower_data[turret_type]["friendly_damage"]
	get_parent().add_child(new_projectile)
	#target_enemy.on_hit(GameStats.tower_data[turret_type]["damage"])
	yield(get_tree().create_timer((GameStats.tower_data[turret_type]["fire_rate"])/GameStats.fire_rate_multiplier), "timeout")
	ready = true

