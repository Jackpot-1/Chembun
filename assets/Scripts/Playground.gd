extends Node3D


func _enter_tree():
	if Globals.last_position:
		$PlayerTemplate.global_position = Globals.last_position
func _ready():
	pass
	
