extends MeshInstance3D

# Speed of rotation
var rotation_speed = 0.10

func _process(delta):
	# Rotate around the Y-axis
	rotate_y(rotation_speed * delta)
