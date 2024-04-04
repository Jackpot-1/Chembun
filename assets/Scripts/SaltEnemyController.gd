extends CharacterBody3D
var data = Globals.EnemyDatabase.SaltBlock
@onready var player_path : NodePath
@onready var animation_Tree = $AnimationTree
@onready var saltCube = $"."
@onready var playback = animation_Tree.get("parameters/playback")
@export var saltDamage = 2
var tween = Tween.new()
#Animations
var animations = {"walking":"Walk", "alert":"Salt_Surprise", "attack1":"dive_start", "attack2":"Dive_Hold"}

var movementVector = Vector3(-1, 0, 0)
var moveSpeed = 5
var movement
var playerTargeting = false
var runOnce = false
var hasDived = false

@export var movement_speed: float = 4.0
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	if hasDived:
		if animations.attack2 in playback.get_current_node():
			playerTargeting = false
			await get_tree().create_timer(1).timeout
			saltCube.queue_free()
	elif playerTargeting:
		set_movement_target(Globals.player.transform.origin)
		look_at(Globals.player.transform.origin * Vector3(1, 0, 1))
		self.rotate_object_local(Vector3(0,1,0), 3.14) #flips the salt cube 180 degrees cause look_at() is weird
	if animations.alert in playback.get_current_node():
		return
	if !playerTargeting:
		return
	#var plr = $"../../PlayerTemplate"
	
	#self.rotate_object_local(Vector3(0,1,0), 3.14) #flips the salt cube 180 degrees cause look_at() is weird
	#look_at(plr.transform.origin)
	#look_at($"../../PlayerTemplate".transform.origin)
	
	if navigation_agent.is_navigation_finished(): #USED THIS INSTEAD OF COLISIONS
		#globals.player.health_checker(saltDamage)
	#
		#playback.travel(dive_hold)
		#saltCube.queue_free()
		return
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()
	
func _ready():
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	playback.travel(animations.walking)

func _on_area_3d_body_entered(body): #The AttackRange, I.E. where it will start to attack from
	if body != Globals.player:
		return
	movement_speed = 10
	if !hasDived:
		playback.travel(animations.attack1)
	hasDived = true

func _on_hit_box_body_entered(body): #If it touches this then the player will take damage
	if body != Globals.player:
		return
	Globals.player.health_checker(saltDamage)
	Globals.player.knockback_enter(rotation, data.knockback)
	
	playback.travel(animations.attack2)
	saltCube.queue_free()

func _on_detection_range_body_entered(body):
	if body != Globals.player:
		return
	if runOnce:
		return
	playback.travel(animations.alert)
	playerTargeting = true
	runOnce = true
	#run to player

func _on_detection_range_body_exited(body):
	if body!= Globals.player:
		return
	playerTargeting = false
