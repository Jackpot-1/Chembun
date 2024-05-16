extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

var doubleLevelCheck = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_home_button_up():
	get_tree().change_scene_to_file("res://assets/Scenes/Level/Overworld/overworld.tscn")


func _on_canyon_button_up():
	get_tree().change_scene_to_file("res://assets/Scenes/Level/Canyon/canyon.tscn")


func _on_mystery_button_up():
	#get_tree().change_scene_to_file("res://assets/Scenes/Level/Map_Select/Level_Select.tscn")
	pass


func _on_ost_chem_god_finished():
	$"OST-ChemGod".play()
