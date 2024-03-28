extends CharacterBody3D

# Grabs the prebuilt AnimationTree 
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var player = $"."
@onready var globals = $"/root/Globals"
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
var aim_turn: float
var movement: Vector3
var vertical_velocity: Vector3
var movement_speed: int
var angular_acceleration: int
var acceleration: int
# misc
var jump_counter: int
var knockback: Vector3

func _ready(): # Camera based Rotation
	globals.player = $"."
	direction = Vector3.BACK.rotated(Vector3.UP, $Camroot/h.global_transform.basis.get_euler().y)

func _input(event): # All major mouse and button input events
	if event is InputEventMouseMotion && !canvas.playerStopped:
		aim_turn = -event.relative.x * 0.015 # animates player with mouse movement while aiming
	if event.is_action_pressed("aim") && !canvas.playerStopped: # Aim button triggers a strafe walk and camera mechanic
		$CamRightTank/h/v/Camera3D.make_current()
		direction = $Camroot/h.global_transform.basis.z
	elif event.is_action_released("aim") && !canvas.playerStopped:
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

func attack1(): # If not doing other things, start attack1
	if (animations.idle in playback.get_current_node() || animations.walk in playback.get_current_node()) && is_on_floor():
		if Input.is_action_just_pressed("attack") && !canvas.playerStopped && !states.attacking:
			playback.travel(animations.attack1)

func attack2(): # If attack1 is animating, combo into attack 2
	if animations.attack1 in playback.get_current_node(): # Big Attack if sprinting, adds a dash
		if Input.is_action_just_pressed("attack"):
			playback.travel(animations.attack2)

func attack3(): # If attack2 is animating, combo into attack 3. This is a template.
	if animations.attack2 in playback.get_current_node():
		if Input.is_action_just_pressed("attack"):
			pass #no current animation, but add it's playback here!

func rollattack(): # If attack pressed while rolling, do a special attack afterwards.
	if animations.roll in playback.get_current_node():
		if Input.is_action_just_pressed("attack"):
			playback.travel(animations.rollattack) #change this animation for a different attack

func bigattack(): # If attack pressed while springing, do a special attack
	if animations.run in playback.get_current_node(): # Big Attack if sprinting, adds a dash
		if Input.is_action_just_pressed("attack"):
			horizontal_velocity = direction * dash_power
			playback.travel(animations.bigattack) #Add and Change this animation node for a different attack

func _physics_process(delta):
	rollattack()
	bigattack()
	attack1()
	attack2()
	attack3()
	sprint_and_roll()
	
	movement_speed = 0
	angular_acceleration = 20
	acceleration = 15
	
	# State control for is jumping/falling/landing
	states.grounded = is_on_floor() 
	# Defining attack state: Add more attacks animations here as you add more!
	states.attacking = (animations.attack1 in playback.get_current_node() || animations.attack2 in playback.get_current_node() || animations.rollattack in playback.get_current_node() || animations.bigattack in playback.get_current_node())
	# Gravity mechanics and prevent slope-sliding
	if !states.grounded:
		vertical_velocity += Vector3.DOWN * gravity * 2 * delta
	else:
		#vertical_velocity = -get_floor_normal() * gravity / 3
		vertical_velocity = Vector3.DOWN * gravity / 10

	# Giving BigAttack some Slide
	if animations.bigattack in playback.get_current_node():
		acceleration = 3346
		
	# Defining Roll state and limiting movment during rolls
	if animations.roll in playback.get_current_node():
		states.rolling = true
		acceleration = 2
		angular_acceleration = 2
	else:
		states.rolling = false
	
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
	if (Input.is_action_pressed("forward") || Input.is_action_pressed("backward") || Input.is_action_pressed("left") || Input.is_action_pressed("right")):
		if(!canvas.playerStopped):
			states.moving = true;
			direction = Vector3(Input.get_action_strength("left") - Input.get_action_strength("right"), 0, Input.get_action_strength("forward") - Input.get_action_strength("backward"))
			direction = direction.rotated(Vector3.UP, $Camroot/h.global_transform.basis.get_euler().y).normalized()
			# Sprint input, dash state and movement speed
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
		angular_acceleration = 60
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, $Camroot/h.rotation.y, delta * angular_acceleration)
	else: # Normal turn movement mechanics
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(direction.x, direction.z) - rotation.y, delta * angular_acceleration)
	
	# Movment mechanics with limitations during rolls/attacks
	if (states.attacking || states.rolling):
		horizontal_velocity = horizontal_velocity.lerp(direction.normalized() * .01 , acceleration * delta)
	else: # Movement mechanics without limitations
		horizontal_velocity = horizontal_velocity.lerp(direction.normalized() * movement_speed, acceleration * delta)
	
	# The Physics Sauce. Movement, gravity and velocity in a perfect dance.
	# Except, this literally makes knockback impossible goofies
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
	# health stuff

func _process(delta):
	pass

func health_checker(damage_taken):
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

func knockback_enter(strength:int, direction:Vector3):
	knockback = Vector3(0,0,strength*10).rotated(Vector3.UP, direction.y)
	$KnockbackTimer.start()

func knockback_timeout():
	states.knockback = false
	knockback = Vector3.ZERO
