extends Node

var PlayerMoney
var current_wave
var time_till_next_wave
var fire_rate_multiplier = 10

var tower_data = {
	"CannonT1": {
		"damage": 20,
		"range": 256,
		"fire_rate": 1.0,
		"cost": 100
		},
	
	"MissileT1": {
			"damage": 100,
			"range": 256,
			"fire_rate": 9,
			"cost": 200
		}
	}

var enemy_data = {
	"greyAPC": {
		"speed": 75,
		"health": 100,
		"reward": 10
	}
}

var lvlwaves = {
	"TestLevel": {
		"wave0": [["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9]],
		"wave1": [["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9]],
		"wave2": [["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9], ["greyAPC", 0.9]]
	}
}
