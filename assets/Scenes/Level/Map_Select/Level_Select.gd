extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)

var doubleLevelCheck = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_home_button_up():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Globals.current_scene = "res://assets/Scenes/Level/Overworld/overworld.tscn"
	Globals.position = Vector3(-24.71,5.363,-1.916)
	Globals.save()
	get_tree().change_scene_to_file("res://assets/Scenes/Level/Overworld/overworld.tscn")


func _on_canyon_button_up():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Globals.current_scene = "res://assets/Scenes/Level/Canyon/canyon.tscn"
	Globals.save()
	get_tree().change_scene_to_file("res://assets/Scenes/Level/Canyon/canyon.tscn")


func _on_mystery_button_up():
	#get_tree().change_scene_to_file("res://assets/Scenes/Level/Map_Select/Level_Select.tscn")
	pass


func _on_ost_chem_god_finished():
	$"OST-ChemGod".play()
