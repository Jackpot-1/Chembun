extends MeshInstance3D

var rotation_speed = 0.1

func _process(delta):
	rotate_y(rotation_speed * delta)
