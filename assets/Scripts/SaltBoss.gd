extends CharacterBody3D
var data = Globals.EnemyDatabase.SaltBlock # test of globals data
@onready var player_path : NodePath
@onready var animation_Tree = $AnimationTree
@onready var saltCube = $"."
@onready var playback = animation_Tree.get("parameters/playback")
var saltDamage = 2
var tween = Tween.new()
#Animations
var animations = {"walk":"Walk", "alert":"Salt_Surprise", "attack1":"dive_start", "attack2":"Dive_Hold"}

var movementVector = Vector3(-1, 0, 0)
var moveSpeed = 5
var playerTargeting = false
var justLookAt = false
var runOnce = false
var hasDived = false
var invulnerable = false

@export var vulnerable_to = "Water"

@export var rotation_speed: float = 12
@export var movement_speed: float = 4.0
@export var total_health: float = 6.0
var current_health: float = total_health
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")
var rng = RandomNumberGenerator.new()


func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta):
	if Input.is_action_just_pressed("skip"): charge_attack()
	if hasDived:
		if animations.attack2 in playback.get_current_node():
			playerTargeting = false
			await get_tree().create_timer(0.2).timeout
			playback.travel("Dive_Hold 2")
			hasDived = false
			
	elif playerTargeting:
		if roundf(rng.randf_range(0, 300)) == 69: charge_attack(); return
		set_movement_target(Globals.player.transform.origin)
		smooth_look_at(Vector3(Globals.player.position.x, position.y, Globals.player.position.z), rotation_speed * delta)
	elif justLookAt: smooth_look_at(Vector3(Globals.player.position.x, position.y, Globals.player.position.z), rotation_speed * delta)
	if animations.alert in playback.get_current_node():
		return
	if !playerTargeting: return
	#var plr = $"../../PlayerTemplate"
	
	#self.rotate_object_local(Vector3(0,1,0), 3.14) #flips the salt cube 180 degrees cause look_at() is weird
	#look_at(plr.transform.origin)
	#look_at($"../../PlayerTemplate".transform.origin)
	
	if navigation_agent.is_navigation_finished():
		return
	
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	
func smooth_look_at(target: Vector3, weight: float) -> void:
	var look_transform = global_transform.looking_at(target)
	global_transform.basis.x = lerp(global_transform.basis.x, -look_transform.basis.x, weight)
	scale = Vector3.ONE

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()
	
func _ready():
	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	playback.travel(animations.walk)
	
	
func charge_attack():
	#$"Salt Block/Skeleton3D/Cube".get_surface_override_material(0).albedo_color = Color.html("#ff655d")
	$Sprite3D.visible = true
	$"Salt Block/Skeleton3D/Cube".set("blend_shapes/anger", 1)
	playerTargeting = false
	justLookAt = true
	await get_tree().create_timer(1).timeout
	justLookAt = false
	await get_tree().create_timer(0.2).timeout
	$Sprite3D.visible = false
	invulnerable = true
	#dashLocation = $"Salt Block".global_position + Vector3(0, 0, 4)
	#dashLocation = $SpringArm3D/Marker3D.global_position
	#velocity = Vector3(10, 0, 0)
	movement_speed = 20
	var new_velocity: Vector3 = global_position.direction_to($DashMarker3D.global_position) * movement_speed
	$DashTimer.start()
	while(true):
		await get_tree().create_timer(get_process_delta_time()).timeout
		_on_velocity_computed(new_velocity)
		if $DashTimer.is_stopped(): break
	playerTargeting = true
	movement_speed = 2
	invulnerable = false
	#$"Salt Block/Skeleton3D/Cube".get_surface_override_material(0).albedo_color = "ffffff"
	$"Salt Block/Skeleton3D/Cube".set("blend_shapes/anger", 0)
	
	#dashTargeting = true

func _on_area_3d_body_entered(body): #The AttackRange, I.E. where it will start to attack from
	if body != Globals.player:
		return
	print("attack range")
	movement_speed = 5
	if !hasDived:
		playback.travel(animations.attack1)
	hasDived = true
	movement_speed = 2

func _on_hit_box_body_entered(body): #If it touches this then the player will take damage
	if body != Globals.player: return
	#if body.name == vulnerable_to:
		#saltCube.queue_free()
	
	if body.name == Globals.currItem:
		#print("check")
		pass
	elif body == Globals.player:
		Globals.player.hurt(saltDamage)
		Globals.player.knockback_enter(rotation, data.knockback)
		playback.travel(animations.attack2)
		#saltCube.queue_free()
		
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
	if runOnce:
		return
	playback.travel(animations.alert)
	playerTargeting = true
	runOnce = true
	#run to player

#func _on_detection_range_body_exited(body):
	#if body!= Globals.player:
		#return
	#playerTargeting = false
	#runOnce = false
	
	


func _on_hit_box_area_entered(area):
	if not $DamageCooldown.is_stopped(): return
	if invulnerable: return
	if area.name != "splashRadius": return
	if area.get_parent().Name == "Water":
		$DamageCooldown.start()
		print(current_health/total_health * 100)
		print(current_health)
		for i in range(10):
			await get_tree().create_timer(0.01).timeout
			#print(i, " i")
			var n: float = i+1
			$"Salt Block/Skeleton3D/BoneAttachment3D/Sprite3D/SubViewport/ProgressBar".value = (current_health-n/10)/total_health * 100
			#print([current_health-i/10, total_health])
			#print([current_health, i/10, current_health-i/10])
			#print((current_health-i/10)/total_health)
		current_health -= 1
		if current_health <= 0: self.queue_free()
	(6-1/10)/6

var previousAnim = ""
func _on_animation_tree_animation_finished(anim_name):
	#if anim_name == "Salt_Surprise": $"Salt Block/Skeleton3D/Cube".set("blend_shapes/Anger", 1)
	print(previousAnim, " ", anim_name)
	if previousAnim == "Dive_Hold" && anim_name == "dive_start": playerTargeting = true
	previousAnim = anim_name



