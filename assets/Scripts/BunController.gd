extends CharacterBody3D

# Grabs the prebuilt AnimationTree 
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
var pb_node
@onready var player = $"."
@onready var canvas = $"../CanvasLayer"
@export var health = 10

@onready var carror_dir = [
	$"../CanvasLayer/carrotHalf",
	$"../CanvasLayer/carrot",
	$"../CanvasLayer/carrotHalf2",
	$"../CanvasLayer/carrot2",
	$"../CanvasLayer/carrotHalf3",
	$"../CanvasLayer/carrot3",
	$"../CanvasLayer/carrotHalf4",
	$"../CanvasLayer/carrot4",
	$"../CanvasLayer/carrotHalf5",
	$"../CanvasLayer/carrot5"
]

# Allows to pick your chracter's mesh from the inspector
@export_node_path("Node3D") var PlayerCharacterMesh: NodePath
@onready var player_mesh = get_node(PlayerCharacterMesh)

# Gamplay mechanics and Inspector tweakables
@export var gravity = 9.8
@export var jump_force = 9
@export var walk_speed = 4
@export var run_speed = 6
@export var dash_power = 12 # Controls roll and big attack speed boosts

##Combat Throwing Stuff
var tankMode = false
#const flaskPreload = preload("res://assets/Miscellaneous/Flask.tscn")
var blob = preload("res://assets/Items/3D/blob.glb")
var blobInstance

var animations = {
	"roll": "Roll",
	"idle": "Idle",
	"walk": "Walk",
	"run": "Run",
	"jump": "Jump",
	"attack1": "kungfu-mixamo",
	"attack2": "Attack2",
	"bigattack": "BigAttack",
	"rollattack": "RollAttack"
}

# Condition States
# Guys I swear did you forget the year long python lesson use dictionaries pleasssssssse
var states = {
	"moving": null,
	"grounded": null,
	"attacking": null,
	"rolling": null,
	"walking": null,
	"running": null,
	"knockback": null,
	"stopped": null
}

# Physics values
var direction: Vector3
var horizontal_velocity: Vector3
var movement: Vector3
var vertical_velocity: Vector3
var movement_speed: int
var angular_acceleration: int
var acceleration: int
# misc
var jump_counter: int
var knockback: Vector3

func _ready():
	Globals.player = $"."
	#direction = Vector3.BACK.rotated(Vector3.UP, $Camroot/h.global_transform.basis.get_euler().y)

func _input(event): # All major mouse and button input events
	if(canvas.playerStopped):
		return
	if event.is_action_pressed("aim"): # Aim button triggers a strafe walk and camera mechanic
		$CamRightTank/h/v/Camera3D.make_current()
		direction = $Camroot/h.global_transform.basis.z
		blobInstance = blob.instantiate()
		add_child(blobInstance)
		blobInstance.position = Vector3(0, 1, 1)
	if event.is_action_released("aim"):
		$Camroot/h/v/Camera3D.make_current()
		direction = $Camroot/h.global_transform.basis.z

func sprint_and_roll():
	# Dodge button input with dash and interruption to basic actions
	if Input.is_action_just_pressed("sprint"):
		if !animations.roll in playback.get_current_node() && !animations.jump in playback.get_current_node() && !animations.bigattack in playback.get_current_node():
			$DashTimer.start()

	if Input.is_action_just_released("sprint") && !$DashTimer.is_stopped() && states.moving:
		$DashTimer.stop()
		playback.start(animations.roll) #"start" not "travel" to speedy teleport to the roll!
		horizontal_velocity = direction * dash_power
		states.rolling = true

func _physics_process(delta):
	#rollattack()
	#bigattack()
	attack1()
	#attack2()
	#attack3()
	sprint_and_roll()
	
	pb_node = playback.get_current_node()
	
	movement_speed = 0
	angular_acceleration = 20
	acceleration = 15
	
	#moving defined elsewhere
	states.grounded = is_on_floor() 
	states.attacking = animations.attack1 in pb_node || animations.attack2 in pb_node || animations.rollattack in pb_node || animations.bigattack in pb_node
	#states.running = animations.run in pb_node || animations.bigattack in pb_node
	#states.walking = animations.walk in pb_node
	states.jumping = animations.jump in pb_node
	states.rolling = animations.roll in pb_node || animations.rollattack in pb_node
	
	# Gravity mechanics and prevent slope-sliding
	if !states.grounded:
		vertical_velocity += Vector3.DOWN * gravity * 2 * delta
	else:
		#vertical_velocity = -get_floor_normal() * gravity / 3
		vertical_velocity = Vector3.DOWN * gravity / 10

	# Giving BigAttack some Slide
	if animations.bigattack in pb_node:
		acceleration = 300
		
	# Defining Roll state and limiting movment during rolls
	if animations.roll in pb_node:
		acceleration = 2
		angular_acceleration = 2
	
	# Jump input and Mechanics
	if Input.is_action_just_pressed("jump") && !canvas.playerStopped && !states.attacking && !states.rolling:
		if states.grounded:
			jump_counter = 0
			vertical_velocity = Vector3.UP * jump_force
			jump_counter += 1
		elif jump_counter == 1 || jump_counter == 0:
			vertical_velocity = Vector3.UP * (jump_force + 3)
			jump_counter += 1
		elif jump_counter == 2:
			jump_counter += 1
		
	# Movement input, state and mechanics. *Note: movement stops if attacking
	if ((Input.is_action_pressed("forward") || Input.is_action_pressed("backward") || Input.is_action_pressed("left") || Input.is_action_pressed("right")) && !canvas.playerStopped):
		states.moving = true;
		direction = Vector3(Input.get_action_strength("left") - Input.get_action_strength("right"), 0, Input.get_action_strength("forward") - Input.get_action_strength("backward"))
		direction = direction.rotated(Vector3.UP, $Camroot/h.global_transform.basis.get_euler().y).normalized()
		if Input.is_action_pressed("sprint") && $DashTimer.is_stopped():
			movement_speed = run_speed
			states.running = true
			states.walking = true
		else: # Walk State and speed
			movement_speed = walk_speed
			states.running = false
			states.walking = true
	else:
		states.walking = false
		states.running = false
		states.moving = false

	if Input.is_action_pressed("aim") && !canvas.playerStopped:  # Aim/Strafe input and  mechanics
		tankMode = true
		angular_acceleration = 60
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, $CamRightTank/h.rotation.y, delta * angular_acceleration)
	else: # Normal turn movement mechanics
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(direction.x, direction.z) - rotation.y, delta * angular_acceleration)
	
	if Input.is_action_just_released("aim"):
		tankMode = false
	
	# Movment mechanics with limitations during rolls/attacks
	if (states.attacking || states.rolling):
		horizontal_velocity = horizontal_velocity.lerp(direction.normalized() * .01 , acceleration * delta)
	else: # Movement mechanics without limitations
		horizontal_velocity = horizontal_velocity.lerp(direction.normalized() * movement_speed, acceleration * delta)
	
	# The Physics Sauce. Movement, gravity and velocity in a perfect dance.
	# Stirred with love and care by Chef Dimitry
	velocity.z = horizontal_velocity.z + vertical_velocity.z
	velocity.x = horizontal_velocity.x + vertical_velocity.x
	velocity.y = vertical_velocity.y
	velocity += knockback
	
	move_and_slide()

	# ========= State machine controls =========
	# The booleans of the states.grounded, states.walking etc, trigger the 
	# advanced conditions of the AnimationTree, controlling animation paths
	
	# on_floor manages jumps and falls
	animation_tree["parameters/conditions/IsOnFloor"] = states.grounded
	animation_tree["parameters/conditions/IsInAir"] = !states.grounded
	# Moving and running respectively
	animation_tree["parameters/conditions/IsWalking"] = states.walking
	animation_tree["parameters/conditions/IsNotWalking"] = !states.walking
	animation_tree["parameters/conditions/IsRunning"] = states.running
	animation_tree["parameters/conditions/IsNotRunning"] = !states.running
	# Attacks and roll don't use these boolean conditions, instead
	# they use "travel" or "start" to one-shot their animations.

func attack1():
	if not states.attacking && not states.running && not states.rolling && states.grounded:
		if Input.is_action_just_pressed("attack") && !canvas.playerStopped && !states.attacking:
			if tankMode == true:
				print("in tank mode and attacked")
				print("")
				#create new instance and set its position to Chembun with the instance slightly infront of it
				
				
			else:
				print("not in tank mode")
			#playback.travel(animations.attack1)

#func attack2():
	#if animations.attack1 in playback.get_current_node(): 
		#if Input.is_action_just_pressed("attack"):
			##playback.start(animations.attack2) #There's currently no attack2
			#pass
#
#func attack3():
	#if animations.attack2 in playback.get_current_node():
		#if Input.is_action_just_pressed("attack"):
			##playback.start(animations.attack3) #There's currently no attack3
			#pass
#
#func rollattack(): # If attack pressed while rolling, do a special attack afterwards.
	#if animations.roll in playback.get_current_node() and not states.attacking:
		#if Input.is_action_just_pressed("attack"):
			##playback.start(animations.rollattack)
			#pass
#
#func bigattack(): # If attack pressed while sprinting, do a special attack
	#if animations.run in playback.get_current_node() and not states.attacking and not states.rolling: # Big Attack if sprinting, adds a dash
		#if Input.is_action_just_pressed("attack"):
			#horizontal_velocity = direction * dash_power
			##playback.start(animations.bigattack) #Add and Change this animation node for a different attack

func hurt(damage_taken):
	var old_health = health
	health -= damage_taken
	if health <= 0:
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://assets/Scenes/Screens/DeathScreen.tscn")
	else:
		for i in range(damage_taken):
			old_health -= 1
			carror_dir[old_health].visible = false
		$RegenTimer.start()

func regen():
	carror_dir[health].visible = true
	health+=1
	if !(health == 10):
		$RegenTimer.start()

func knockback_enter(direction:Vector3, strength: Vector3):
	knockback = strength.rotated(Vector3.UP, direction.y)
	states.knockback = true
	$KnockbackTimer.start()

func knockback_exit():
	states.knockback = false
	knockback = Vector3.ZERO

