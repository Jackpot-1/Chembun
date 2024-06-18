extends CharacterBody3D

# Grabs the prebuilt AnimationTree 
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
var pb_node
@onready var player = $"."
@onready var canvas = $"../CanvasLayer"
@export var health = 10

@onready var carror_dir = [
	$"../CanvasLayer/carrots/carrotHalf",
	$"../CanvasLayer/carrots/carrot",
	$"../CanvasLayer/carrots/carrotHalf2",
	$"../CanvasLayer/carrots/carrot2",
	$"../CanvasLayer/carrots/carrotHalf3",
	$"../CanvasLayer/carrots/carrot3",
	$"../CanvasLayer/carrots/carrotHalf4",
	$"../CanvasLayer/carrots/carrot4",
	$"../CanvasLayer/carrots/carrotHalf5",
	$"../CanvasLayer/carrots/carrot5"
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
const blobPreload = preload("res://assets/items/betterblob.tscn")
var blobInstance
var blob
var aimIsPressed = false

var animations = {
	"roll": "Roll",
	"idle": "Idle",
	"walk": "Walk",
	"run": "Run",
	"jump": "Jump",
	"double_jump": "double jump",
	"attack1": "kungfu-mixamo",
	"attack2": "Attack2",
	"bigattack": "BigAttack",
	"rollattack": "RollAttack",
	"fall": "jump_fall",
	"doublejump": "double jump",
	"knockback": "knockback"
}

# Condition States
# Guys I swear did you forget the year long python lesson use dictionaries pleasssssssse
var states = {
	"moving": null,
	"grounded": null,
	"falling": null,
	"jumping": null,
	"doublejumping" : null,
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
var Ystopper = false
var isKnockbackPlaySound = false #used to play the "oof" sfx when you land on the ground in knockback

func _ready():
	Globals.player = $"."
	#direction = Vector3.BACK.rotated(Vector3.UP, $Camroot/h.global_transform.basis.get_euler().y)
	key()

func _input(event): # All major mouse and button input events
	if Globals.CameraSwitch: return
	if is_instance_valid(canvas):
		if(canvas.playerStopped): return
	if event.is_action_pressed("aim"): # Aim button triggers a strafe walk and camera mechanic
		$CamRightTank/h/v/Camera3D.make_current()
		aimIsPressed = true
		# the throwing stuff is in physics process so we can instantiate 
		# another potion if you are still holding the aim button


	if event.is_action_released("aim"):
		aimIsPressed = false
		
		if Globals.blobReady:
			blobInstance.free()
			Globals.blobReady = false
		$Camroot/h/v/Camera3D.make_current()
		direction = $Camroot/h.global_transform.basis.z
		#direction = $Camroot/h.rotation

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

	#print(Globals.blobFired, " blobFired")
		#print(blobInstance.linear_velocity)
		#await get_tree().create_timer(1).timeout
		#blobInstance.linear_velocity = Vector3(1, 0, 0)
		#blobInstance.gravity_scale = 1
	#states.falling = velocity.y < 0
	#print(animations.doublejump in pb_node)
	#if animations.doublejump in pb_node:
		#$DoubleJumpTimer.start()
		#Ystopper = true
		#vertical_velocity = Vector3(0, 0, 0)
		
	if isKnockbackPlaySound:
		var offTheGround = false
		if not states.grounded: offTheGround = true
		if states.grounded and offTheGround: 
			isKnockbackPlaySound = false
			$Oof.play()
		
	if velocity.y < 0:
		states.falling = true
		if animations.doublejump not in pb_node:
			playback.travel(animations.fall)
		
	else: states.falling = false
	states.attacking = animations.attack1 in pb_node || animations.attack2 in pb_node || animations.rollattack in pb_node || animations.bigattack in pb_node
	#states.running = animations.run in pb_node || animations.bigattack in pb_node
	#states.walking = animations.walk in pb_node
	states.jumping = animations.jump in pb_node
	#states.falling = animations.fall in pb_node
	states.rolling = animations.roll in pb_node || animations.rollattack in pb_node
	
	# Gravity mechanics and prevent slope-sliding
	if !states.grounded and Ystopper == false:
		vertical_velocity += Vector3.DOWN * gravity * 2 * delta
	elif Ystopper == true: pass
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
	if Input.is_action_just_pressed("jump") && !states.attacking && !states.rolling:
		if not Globals.CameraSwitch:
			if canvas.playerStopped: return
		if states.grounded:
			#states.doublejumping = false
			jump_counter = 0
			vertical_velocity = Vector3.UP * jump_force
			jump_counter += 1
			playback.travel(animations.jump)
		#the double jump ⬇️
		elif jump_counter == 1 || jump_counter == 0:
			$DoubleJumpTimer.start()
			Ystopper = true
			vertical_velocity = Vector3(0, -0.1, 0)
			if Ystopper == false: vertical_velocity = Vector3.UP * (jump_force + 3)
			#states.double_jumping = animations.double_jump in pb_node
			jump_counter += 1
			playback.travel(animations.doublejump)
			await get_tree().create_timer(.5).timeout
			$Explosion.play()
			#states.doublejumping = true
		elif jump_counter == 2:
			jump_counter += 1
			#jump_counter = 0
		
	# Movement input, state and mechanics. *Note: movement stops if attacking
	if ((Input.is_action_pressed("forward") || Input.is_action_pressed("backward") || Input.is_action_pressed("left") || Input.is_action_pressed("right"))):
		if not Globals.CameraSwitch:
			if canvas.playerStopped: return
		direction = Vector3(Input.get_action_strength("left") - Input.get_action_strength("right"), 0, Input.get_action_strength("forward") - Input.get_action_strength("backward"))
		direction = direction.rotated(Vector3.UP, $Camroot/h.global_transform.basis.get_euler().y).normalized()
		#$Walk.play()
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

	if Input.is_action_pressed("aim"):  # Aim/Strafe input and  mechanics
		if Globals.CameraSwitch: return
		if canvas.playerStopped: return
		tankMode = true
		angular_acceleration = 60
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, $CamRightTank/h.rotation.y, delta * angular_acceleration)
		
	else: # Normal turn movement mechanics
		player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(direction.x, direction.z) - rotation.y, delta * angular_acceleration)
	
	if Input.is_action_just_released("aim"):
		tankMode = false
	if Input.is_action_pressed("aim"):
		if aimIsPressed and not Globals.blobFired and not Globals.blobReady and Globals.currItem != "":
			direction = $Camroot/h.global_transform.basis.z
			#print(blobPreload.can_instantiate())
			blobInstance = blobPreload.instantiate()
			#blobInstance = load("res://assets/items/Betterblob.tscn").instantiate()
			blobInstance.Name = Globals.currItem
			blobInstance.color = Globals.color
			$chemcloth.add_child(blobInstance)
			blobInstance.position = Vector3(-0.4, 1, 1)
			Globals.blobReady = true
	
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
	
	#fallback incase the animation gets canceled and you can't stop getting knocked back
	if knockback != Vector3.ZERO and !animations.knockback in pb_node:
		await get_tree().create_timer(.5).timeout # the knockback gets set before the animation plays, so we have to check again
		if knockback != Vector3.ZERO and !animations.knockback in pb_node:
			knockback = Vector3.ZERO
	move_and_slide()

	# ========= State machine controls =========
	# The booleans of the states.grounded, states.walking etc, trigger the 
	# advanced conditions of the AnimationTree, controlling animation paths
	
	# on_floor manages jumps and falls
	animation_tree["parameters/conditions/IsFalling"] = states.falling
	animation_tree["parameters/conditions/IsOnFloor"] = states.grounded
	animation_tree["parameters/conditions/IsJumping"] = states.jumping
	animation_tree["parameters/conditions/IsDoubleJumping"] = states.doublejumping
	
	# Moving and running respectively
	animation_tree["parameters/conditions/IsWalking"] = states.walking
	animation_tree["parameters/conditions/IsNotWalking"] = !states.walking
	animation_tree["parameters/conditions/IsRunning"] = states.running
	animation_tree["parameters/conditions/IsNotRunning"] = !states.running
	# Attacks and roll don't use these boolean conditions, instead
	# they use "travel" or "start" to one-shot their animations.

func attack1():
	if not states.attacking && not states.rolling:
		if Input.is_action_just_pressed("attack") && !states.attacking:
			if not Globals.CameraSwitch:
				if canvas.playerStopped: return
			if tankMode == true && Globals.blobReady == true:
				#blobInstance.velocity = Vector3(1, 0, 1)
				if is_instance_valid(blobInstance):
					blobInstance.global_rotation = $CamRightTank/h/v/Camera3D.global_rotation
					#blobInstance.linear_velocity = -blobInstance.transform.basis.z.normalized() * 10
					blobInstance.apply_central_impulse(blobInstance.global_transform.basis.z * 6 * -1) # bro this line of code took like 10 hours
					blobInstance.apply_central_impulse(blobInstance.global_transform.basis.y * 2)
					#blobInstance.position += Vector3(0.5, 0, 3)
					#blobInstance.position.y *= -1
					#$Camroot/h/Marker3D.global_position = blobInstance.global_position
					#blobInstance.set_linear_velocity(Vector3(0,1,8).rotated(Vector3.UP, $chemcloth.rotation.y))
					#blobInstance.set_linear_velocity((Vector3(0,1,8).rotated(Vector3.UP, $chemcloth.rotation.y)).rotated(Vector3.RIGHT, $CamRightTank/h/v/Camera3D.global_rotation.z))
					#blobInstance.apply_impulse(Vector3(0,1,8).rotated(Vector3.UP, $CamRightTank/h/v.global_rotation.z))
					#blobInstance.apply_central_impulse(-blobInstance.transform.basis.z * 10)
					#blobInstance.linear_velocity = Vector3(0, 2, 8).rotated(Vector3.UP, $chemcloth.rotation.y) * blobInstance.transform.basis.y
					blobInstance.reparent($".".get_parent())
					Globals.blobReady = false
					Globals.blobFired = true
					$"Throwing".play()
					$"../CanvasLayer/hotbar".cooldown()

					#Globals.GUI.dialogue("Character", "This is door", true, "Key not found", "Door Opened", 5)
					#print(Globals.dialogueChek["Door"]["Key"])
					#Globals.dialogue(name of character thing [string value], Original text [string value], can this be repeated? [boolean] [if false leave next two blank], text to be repeated [string value], final text once you have the key or sum [string value])
				#create new instance and set its position to Chembun with the instance slightly infront of it


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
	$Hurt.play()
	if health <= 0:
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://assets/Scenes/Screens/DeathScreen.tscn")
	elif damage_taken > 0:
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
	playback.travel(animations.knockback)
	isKnockbackPlaySound = true

func knockback_exit():
	states.knockback = false
	knockback = Vector3.ZERO
func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "knockback":
		states.knockback = false
		knockback = Vector3.ZERO


func _on_double_jump_timer_timeout():
	Ystopper = false
	vertical_velocity = Vector3.UP * (jump_force + 3)

func key():
	#if Globals.hasKey: $chemcloth/Keys.visible = true
	#else: $chemcloth/Keys.visible = false
	if Globals.hasKey: $chemcloth/Armature/Skeleton3D/BoneAttachment3D/Keys.visible = true
	else: $chemcloth/Armature/Skeleton3D/BoneAttachment3D/Keys.visible = false

#
#func _on_walk_finished():
	#if self.velocity.is_zero_approx() and states.grounded:
		#$Walk.play()
