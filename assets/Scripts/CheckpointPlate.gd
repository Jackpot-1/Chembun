extends Area3D

func CheckpointTouched(body):
	Globals.last_position = global_position
	Globals.save()
	$"../CanvasLayer/hotbar".slotInserter(load("res://assets/images/items/Water.tres"))
