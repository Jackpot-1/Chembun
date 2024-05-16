extends CharacterBody3D
var data = Globals.EnemyDatabase.Snail # test of globals data
@onready var player_path : NodePath
@onready var animation_Tree = $AnimationTree
@onready var snail = $"."
@onready var playback = animation_Tree.get("parameters/playback")
var snailDamage = 2

#Animations
#var animations = {"happy":"SO HAPPY", "sad":"SOOOO SAD", "death":"death"}

var movementVector = Vector3(-1, 0, 0)
var playerTargeting = false

var random = RandomNumberGenerator.new()

@export var movement_speed: float = 0.5
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	if playerTargeting:
		set_movement_target(Globals.player.transform.origin)
		look_at(Vector3(Globals.player.position.x, position.y, Globals.player.position.z), Vector3.UP)
		self.rotate_object_local(Vector3(0,1,0), 3.14) #flips the salt cube 180 degrees cause look_at() is weird
	if !velocity.is_zero_approx(): 
		playback.travel("idle_snail")
		print(velocity)
	else: playback.stop()
	
	
	
	if navigation_agent.is_navigation_finished(): #USED THIS INSTEAD OF COLISIONS
		#snail.queue_free()
		if not playerTargeting:
			chase()
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
	chase()
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	#playback.travel(animations.sad)
	
func chase():
	$Marker3D.position.x = position.x + randf_range(-5, 5)
	$Marker3D.position.y = position.y
	$Marker3D.position.z = position.z + randf_range(-5, 5)
	look_at(Vector3($Marker3D.position.x, position.y, $Marker3D.position.z), Vector3.UP)
	self.rotate_object_local(Vector3(0,1,0), 3.14)
	set_movement_target($Marker3D.transform.origin)

func _on_area_3d_body_entered(body): #The AttackRange, I.E. where it will start to attack from
	if body != Globals.player:
		return
	#movement_speed = 10

func _on_hit_box_body_entered(body): #If it touches this then the player will take damage
	if body == Globals.player:
		Globals.player.hurt(snailDamage)
		Globals.player.knockback_enter(rotation, data.knockback)
		snail.queue_free()
		
		#Globals.player.hurt(saltDamage)
		#Globals.player.knockback_enter(rotation, data.knockback)
		#playback.travel(animations.attack2)
		#saltCube.queue_free()
	
	#Globals.player.hurt(saltDamage)
	#Globals.player.knockback_enter(rotation, data.knockback)
	#
	#playback.travel(animations.attack2)
	#saltCube.queue_free()

func _on_detection_range_body_entered(body):
	if body != Globals.player:
		return
	print("Player entered detection range")
	playerTargeting = true
	#run to player

func _on_detection_range_body_exited(body):
	print("Player exited detection range")
	if body!= Globals.player:
		return
	playerTargeting = false
	chase()


func _on_hit_box_area_entered(area):
	if area.name != "splashRadius": return
	if area.get_parent().Name == "Water":
		self.queue_free()
