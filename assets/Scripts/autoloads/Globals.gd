extends Node


var save_path = "user://save.save"
var CinematicFinished = true #make sure set to false
var last_position = false
var current_scene = "res://assets/Scenes/Playground.tscn"

func _ready():
	load_data()

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

#var items = [
	#{
		#"name" : "carrot",
		#"icon" : "res://assets/images/items/ccarrot.png",
		#"composition" : "",
		#"attributes" : "food"
	#},
	#{
		#"name" : "water",
		#"icon" : "",
		#"composition" : "H2O",
		#"attributes" : "water"
	#}
#]

#var slots = [
		#{
			#"node" : $CanvasLayer/hotbar/Quarter/Path2D/PathFollow2D/Circle/Panel,
			#"item" : null
		#},
		#{
			#"node" : $CanvasLayer/hotbar/Quarter/Path2D/PathFollow2D2/Circle/Panel,
			#"item" : null
		#},
		#{
			#"node" : $CanvasLayer/hotbar/Quarter/Path2D/PathFollow2D3/Circle/Panel,
			#"item" : null
		#},
		#{
			#"node" : $CanvasLayer/hotbar/Quarter/Path2D/PathFollow2D4/Circle/Panel,
			#"item" : null
		#},
		#{
			#"node" : $CanvasLayer/hotbar/Quarter/Path2D/PathFollow2D5/Circle/Panel,
			#"item" : null
		#}
	#]
	

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
		
#func add_item(dic):
	#if slots[0]["item"] == null:
		#slots[0]["item"] = dic
		#var image = slots[0]["item"]["icon"]
		#print("to the south")
		#var data = ["$CanvasLayer/hotbar/Quarter/Path2D/PathFollow2D/Circle/Panel", image]
		##await $CanvasLayer/hotbar/Quarter/Path2D/PathFollow2D/Circle/Panel.tree_entered
		#return data #.add_item2(image)
	#elif slots[1]["item"] == null:
		#slots[1]["item"] = dic
	#elif slots[2]["item"] == null:
		#slots[2]["item"] = dic
	#elif slots[3]["item"] == null:
		#slots[3]["item"] = dic
	#elif slots[4]["item"] == null:
		#slots[4]["item"] = dic
		
		


var blobReady = false
var blobFired = false
var isCooldown = false
var currItem = ""

func potAttack(body, enemy):
	if EnemyDatabase.has(enemy):
		print(enemy)
	pass

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(CinematicFinished)
	file.store_var(last_position)
	
func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		CinematicFinished = file.get_var(CinematicFinished)
		last_position = file.get_var(last_position)
	else:
		print("bro it doesn't exist stop trying")
		CinematicFinished = false
		last_position = false
		current_scene = "res://assets/Scenes/Playground.tscn"
		
func reset_data():
	CinematicFinished = false
	last_position = false
	current_scene = "res://assets/Scenes/Playground.tscn"
	save()
		
		
		
