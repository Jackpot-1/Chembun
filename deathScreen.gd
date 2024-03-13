extends Control

var rng = RandomNumberGenerator.new()

@onready var deathMessage = $TextureRect/DeathMessage
@onready var messages = [
	"Should've tried harder",
	"Roblox Studio > Godot",
	"Chat, is this real?",
	"Chembun isn't a bunny",
	"First time?",
	"So.. you come here often?",
	"Get good kid",
	"MR.ELECTRIC SEND THIS...",
	"Mushoku Tensei is peak",
	"monster musume",
	"UwU",
	"Should've used Unreal Engine",
	"KleinShaker was here!"
]


# Called when the node enters the scene tree for the first time.
func _ready():
	var my_random_number = rng.randf_range(0, messages.size())
	deathMessage.text = messages[my_random_number]

func ContinueButton():
	get_tree().change_scene_to_file("res://Playground.tscn")

func MainMenuButton():
	get_tree().change_scene_to_file("res://MainMenu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
