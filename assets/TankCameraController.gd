extends Node3D

var camrot_h = 0
var camrot_v = 0
@export var cam_v_max = 75
@export var cam_v_min = -55
@export var joystick_sensitivity = 20
var h_sensitivity = .01
var v_sensitivity = .01
var h_acceleration = 10
var v_acceleration = 10
var joyview = Vector2()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		camrot_h += -event.relative.x * h_sensitivity
		camrot_v += event.relative.y * v_sensitivity
		
func _joystick_input():
	if (Input.is_action_pressed("LeftTurn") || Input.is_action_pressed("RightTurn") || Input.is_action_pressed("UpTurn") || Input.is_action_pressed("DownTurn")):
		joyview.x = Input.get_action_strength("LeftTurn") - Input.get_action_strength("RightTurn")
		joyview.y = Input.get_action_strength("DownTurn") - Input.get_action_strength("UpTurn")

		camrot_h += (joyview.x / 2) * joystick_sensitivity * h_sensitivity
		camrot_v += (joyview.y / 2) * joystick_sensitivity * v_sensitivity
		
func _physics_process(delta):
	_joystick_input()
	camrot_v = clamp(camrot_v, deg_to_rad(cam_v_min), deg_to_rad(cam_v_max))
	$h.rotation.y = lerpf($h.rotation.y, camrot_h, delta * h_acceleration)
	$h/v.rotation.x = lerpf($h/v.rotation.x, camrot_v, delta * v_acceleration)
