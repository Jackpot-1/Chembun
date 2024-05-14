extends VideoStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("skip"): _on_finished()



func _on_finished():
	Globals.CinematicFinished = true
	Globals.save()
	get_tree().change_scene_to_file("res://assets/Scenes/chem crib/Room/chembun_crib.tscn")
