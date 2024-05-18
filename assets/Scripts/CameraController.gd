extends Node3D

# Allows to select the player mesh from the inspector
#@export_node_path(Node3D) var PlayerCharacterMesh: NodePath
#@onready var player_mesh = get_node(PlayerCharacterMesh)

var camrot_h = 0
var camrot_v = 0
@export var cam_v_max = 75 # 75 recommended
@export var cam_v_min = -55 # -55 recommended
@export var joystick_sensitivity = 20
#@export var zoom = 0 #0 is default
var h_sensitivity = .01
var v_sensitivity = .01
var h_acceleration = 10
var v_acceleration = 10
var joyview = Vector2()
var markerPosition
var setMarkerPos = true
var t = 0.0 # for zoom lerp

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	zoom_set()
	
	
func _input(event):
	if Globals.CameraSwitch: return
	if $"../../CanvasLayer".isinventory: return
	if event is InputEventMouseMotion:
		camrot_h += -event.relative.x * h_sensitivity
		camrot_v += event.relative.y * v_sensitivity
		
func _joystick_input():
	if (Input.is_action_pressed("LeftTurn") || Input.is_action_pressed("RightTurn") || Input.is_action_pressed("UpTurn") || Input.is_action_pressed("DownTurn")):
		if($"../../CanvasLayer".isinventory == false):
			#joyview.x = Input.get_action_strength("lookleft") - Input.get_action_strength("lookright")
			joyview.x = Input.get_action_strength("LeftTurn") - Input.get_action_strength("RightTurn")
			joyview.y = Input.get_action_strength("DownTurn") - Input.get_action_strength("UpTurn")

			camrot_h += (joyview.x / 2) * joystick_sensitivity * h_sensitivity
			camrot_v += (joyview.y / 2) * joystick_sensitivity * v_sensitivity
			
func zoom_set():
	#if zoom <= 0: return
	#setMarkerPos = false
	#markerPosition = $h/v/Camera3D/Marker3D.global_transform
	#$h/v/Camera3D/Marker3D.top_level = true
	#print($h/v/Camera3D/Marker3D.global_position, " before " + self.name)
	
	t = 0.0
	while t < 1.0:
		await get_tree().create_timer(0.0001).timeout
		$h.position.y = lerp(float($h.position.y), float(Globals.zoomer/3), t)
		#$h.position.y = Globals.zoomer/3
		$h/v.spring_length = lerp(float($h/v.spring_length), float(-Globals.zoomer - 3), t)
		#$h/v.spring_length = -Globals.zoomer - 3
		t += get_process_delta_time() * 0.5
	
	
	#$h/v/Camera3D/SpringArm3D.spring_length = -Globals.zoomer - 3
	#$h/v/Camera3D/SpringArm3D.position.y = -Globals.zoomer/3
	
	#$h/v/Camera3D/Marker3D.position.y = Globals.zoomer/3
	#$h/v/Camera3D/Marker3D.global_transform = markerPosition
	#$h/v/Camera3D/Marker3D.top_level = false
	#print(markerPosition, " LOOK AT ME ", self.name)
	#if markerPosition != $h/v/Camera3D/Marker3D.global_position:
		#print("ALERT ALERT WEE WOO WEE WOO")
	#setMarkerPos = true
	
func _physics_process(delta):
	#if setMarkerPos:
		#markerPosition = $h/v/Camera3D/Marker3D.global_position
		#print(markerPosition, self.name)
	#$h/Marker3D.set_rotation($h/v/Camera3D.get_rotation())
	# JoyPad Controls
	_joystick_input()
		
	camrot_v = clamp(camrot_v, deg_to_rad(cam_v_min), deg_to_rad(cam_v_max))

	#var mesh_front = player_mesh.global_transform.basis.z
	#var auto_rotate_speed =  (PI - mesh_front.angle_to($pivot.global_transform.basis.z)) * get_parent().horizontal_velocity.length() * rot_speed_multiplier
	
#	if $control_stay_delay.is_stopped():
#		#FOLLOW CAMERA
#		$pivot.rotation.y = lerp_angle($pivot.rotation.y, get_node(PlayerCharacterMesh).global_transform.basis.get_euler().y, delta )
#		camrot_h = $pivot.rotation_degrees.y
#	else:
#		#MOUSE CAMERA
	$h.rotation.y = lerpf($h.rotation.y, camrot_h, delta * h_acceleration)
	$h/v.rotation.x = lerpf($h/v.rotation.x, camrot_v, delta * v_acceleration)
