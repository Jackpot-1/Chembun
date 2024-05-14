extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.CameraSwitch = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body != Globals.player: return
	Globals.current_scene = "res://assets/Scenes/Level/Overworld/overworld.tscn"
	Globals.save()
	Globals.CameraSwitch = false
	get_tree().change_scene_to_file("res://assets/Scenes/Level/Overworld/overworld.tscn")
