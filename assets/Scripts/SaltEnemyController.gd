extends CharacterBody3D
@onready var player_path : NodePath
@onready var animation_Tree = $AnimationTree
@onready var saltCube = $"."
@onready var player = $"../../PlayerTemplate"
@onready var playback = animation_Tree.get("parameters/playback")

var playerFinding = null
const speed = 4.0
@onready var nav_agent = $NavigationAgent3D

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



#var healthWomp = player.get_meta("health")
#healthWomp = player.get_meta("health") - saltDamage

#var healthWomp = player.get_meta("health")

#func _physics_process(delta):
#

#func attack(body):
#		playback.travel(dive_hold)
#		var check_plr_hit = _on_hit_box_body_entered(body)
#		if check_plr_hit == true:
#			var healthWomp = player.get_meta("health")
#			healthWomp -= 1
#			#healthWomp -= saltDamage uncomment this to crash game on touch
#			player.set_meta("health", healthWomp)
#			playback.travel(dive_hold)
#			print(player.get_meta("health"))
#		saltCube.queue_free()

func _ready():
	playback.travel(walking)

func _on_area_3d_body_entered(body): #The AttackRange, I.E. where it will start to attack from
		print("Check")
#		#transform.origin += Vector3(-1, 0, 0)
		playback.travel(dive_start)
		await get_tree().create_timer(2).timeout
		saltCube.queue_free()

func _on_hit_box_body_entered(body): #If it touches this then the player will take damage
	playback.travel(dive_hold)
	#var healthWomp = $"../../PlayerTemplate".get_meta("health")
	#healthWomp -= 2
	##healthWomp -= saltDamage uncomment this to crash game on touch
	#$"../../PlayerTemplate".set_meta("health", healthWomp)
#	playback.travel(dive_hold)
	player.health_checker(saltDamage)
	saltCube.queue_free()

func _on_detection_range_body_entered(body):
	playback.travel(suprise)
	print("suprise")
	#run to player
