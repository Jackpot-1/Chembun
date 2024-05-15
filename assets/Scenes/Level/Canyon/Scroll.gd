extends MeshInstance3D

# Variables for floating effect
var float_amplitude = 0.5  # The maximum distance the object will float from its starting position
var float_speed = 2.0      # Speed at which the object floats
var time_elapsed = 0.0     # Time elapsed since the script started
var original_position

# Variables for rotation
var rotation_speed = 1  # Speed of rotation

func _ready():
	original_position = global_transform.origin

func _process(delta):
	# Floating effect
	time_elapsed += delta
	var float_offset = sin(time_elapsed * float_speed) * float_amplitude
	var new_position = original_position + Vector3(0, float_offset, 0)
	global_transform.origin = new_position

	# Rotation
	# Rotate around the Y-axis
	rotate_y(rotation_speed * delta)
