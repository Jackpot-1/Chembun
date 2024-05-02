extends Area3D

func CheckpointTouched(body):
	Checkpoints.last_position = global_position
	$"../CanvasLayer/hotbar".slotInserter(load("res://assets/images/items/Potion.tres"))
