extends Node3D


func _enter_tree():
	if Checkpoints.last_position:
		$PlayerTemplate.global_position = Checkpoints.last_position
