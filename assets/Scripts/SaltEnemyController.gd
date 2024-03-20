extends CharacterBody3D
@onready var globals = $"/root/Globals"
@onready var player_path : NodePath
@onready var animation_Tree = $AnimationTree
@onready var saltCube = $"."
@onready var playback = animation_Tree.get("parameters/playback")
@export var saltDamage = 2
var tween = Tween.new()
#Animations
var walking = "Walk"
var suprise = "Salt_Surprise"
var dive_start = "dive_start"
var dive_hold = "Dive_Hold"
var movementVector = Vector3(-1, 0, 0)
var moveSpeed = 5
var movement
var playerTargeting = false
var spent = false

@export var movement_speed: float = 4.0
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	if !playerTargeting:
		return
	look_at(globals.player.transform.origin)
	set_movement_target(globals.player.transform.origin)
	if navigation_agent.is_navigation_finished():
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
	playback.travel(walking)

func _on_area_3d_body_entered(body): #The AttackRange, I.E. where it will start to attack from
	spent = true
	playback.travel(dive_start)

func _on_hit_box_body_entered(body): #If it touches this then the player will take damage
	if body != globals.player:
		return
	globals.player.health_checker(saltDamage)
	playback.travel(dive_hold)
	saltCube.queue_free()

func _on_detection_range_body_entered(body):
	if body != globals.player:
		return
	playback.travel(suprise)
	playerTargeting = true
	#run to player

func _on_detection_range_body_exited(body):
	if body!= globals.player:
		return
	playerTargeting = false
