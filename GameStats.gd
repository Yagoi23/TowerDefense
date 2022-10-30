extends Node

var PlayerMoney
var PlayerLives
var current_wave
var time_till_next_wave
var fire_rate_multiplier = 1

#This is where tower information is defined
var tower_data = {
	"CannonT1": {
		"damage": 20,
		"range": 256,
		"fire_rate": 1.0,
		"cost": 50
		},
	
	"MissileT1": {
			"damage": 100,
			"friendly_damage": 20,
			"range": 512,
			"fire_rate": 3,
			"cost": 100,
			"projectile": "Missile",
			"velocity": 15000
		}
	}

#This is where enemy information is defined
var enemy_data = {
	"greyAPC": {
		"speed": 75,
		"health": 100,
		"reward": 10
	}
}

#This is where wave information is defined
var lvlwaves = {
	"TestLevel": {
		"wave0": [["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9]],
		"wave1": [["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9]],
		"wave2": [["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9]],
		"wave3": [["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9]],
		"wave4": [["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9]],
		"wave5": [["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9]],
		"wave6": [["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9]],
		"wave7": [["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9]],
		"wave8": [["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9]],
		"wave9": [["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9]],
		"wave10": [["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9]]
	}
}
