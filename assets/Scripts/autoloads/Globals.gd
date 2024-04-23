extends Node
var player: CharacterBody3D;

var EnemyDatabase = {
	"SaltBlock": {
		"name": "Salt Block",
		"damage": 2,
		"move_speed": 5,
		"vulnerable_to": ["Water"],
		"knockback": Vector3(0,7,10)
	},
	"Snail": {
		"name": "Bob Snail",
		"damage": 0,
		"move_speed": 0.1,
		"vulnerable_to": ["Salt"],
		"knockback": Vector3(0, 5.25, 7.5)
	}
}

var items = [
	{
		"name" : "carrot",
		"icon" : "res://appIcons/ccarrot.png",
		"composition" : "",
		"attributes" : "food"
	},
	{
		"name" : "water",
		"icon" : "",
		"composition" : "H2O",
		"attributes" : "water"
	}
]

class Enemy extends CharacterBody3D:
	var damage: float
	var move_speed: float
	var vulnerable_to: Array
	var animations: Dictionary
	var targeting_player: bool = false
	var tween: Tween = Tween.new()
	@onready var animation_tree: AnimationTree = $AnimationTree
	@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
	var playback = animation_tree.get("parameters/playback")
	@onready var this: Node = $"."
	var data: Dictionary

	func set_movement_target(movement_target: Vector3):
		navigation_agent.set_target_position(movement_target)
	
	func _init(enemy_id):
		data = Globals.EnemyDatabase[enemy_id]
		damage = data.damage
		move_speed = data.move_speed
		vulnerable_to = data.vulnerable_to
		
		
