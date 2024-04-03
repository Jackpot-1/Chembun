extends Node
var player:CharacterBody3D;

var EnemyDatabase = {
	"SaltBlock": {
		"name": "Salt Block",
		"damage": 2,
		"move_speed": 5,
		"vulnerable_to": ["Water"]
	},
	"Snail": {
		"name": "Bob Snail",
		"damage": 0,
		"move_speed": 0.1,
		"vulnerable_to": ["Salt"]
	}
}

class Enemy extends CharacterBody3D:
	var damage: float
	var move_speed: float
	var vulnerable_to: Array
	var animations: Dictionary
	var targeting_player: bool
	
	
	
	func _init(enemy_id):
		var data = Globals.EnemyDatabase[enemy_id]
		damage = data.damage
		move_speed = data.move_speed
		vulnerable_to = data.vulnerable_to
		targeting_player = false
		
