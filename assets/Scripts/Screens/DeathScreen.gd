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
	"Mr Electric send him to the principal's ofﬁce and have him EXPELLED!",
	"Mushoku Tensei is peak",
	"monster musume",
	"UwU",
	"KleinShaker was here!",
	"Gotta get the Ca+Fe+P+Na+K+Mg+Cu+Zn",
	"when the imposter is sus",
	"ඞ",
	"Skill issue",
	"Fatality",
	"U mad bro",
	"your dad would be disapointed",
	"Hey guys, did you know that in terms of male human and female Pokémon breeding, Vaporeon is the most compatible Pokémon for humans? Not only are they in the field egg group, which is mostly comprised of mammals, Vaporeon are an average of 3”03’ tall and 63.9 pounds, this means they’re large enough to be able handle human...",
	"joe mama"
]


# Called when the node enters the scene tree for the first time.
func _ready():
	var my_random_number = rng.randf_range(0, messages.size())
	deathMessage.text = messages[my_random_number]

func ContinueButton():
	get_tree().change_scene_to_file("res://assets/Scenes/Playground.tscn")

func MainMenuButton():
	get_tree().change_scene_to_file("res://assets/Scenes/Screens/MainMenuScreen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
