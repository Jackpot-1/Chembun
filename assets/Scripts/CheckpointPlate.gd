extends Area3D

func CheckpointTouched(body):
	Checkpoints.last_position = global_position
