extends RigidBody3D

@onready var blob = $"."
var done = true
var Name = ""


func _physics_process(delta):
	if Globals.blobFired == false or $".".gravity_scale != 0: return
	else: $".".gravity_scale = 1.262

func _ready():
	$splashRadius/GloopPart.visible = false

func _on_blob_body_entered(body):
	if Globals.blobFired == true: done = false
	if done == true: return
	if body == Globals.player: return
	#$".".gravity_scale = 0
	#$".".linear_velocity = Vector3(0, 0, 0)
	#print(self.name)
	#if body is CSGBox3D:
	#Globals.blobFired = false
	$splashRadius/GloopPart.visible = true
	#if $blob/Cube.visible:
		#$blob/Cube.visible = false
		#$blob/Cube.free()
	$blob/Cube.visible = false
	#$blob/CollisionShape3D.queue_free()
	#$blob/Cube.queue_free()
	#$CollisionShape3D2.disabled = false
	$blob.queue_free()
	self.freeze = true
	#self.gravity_scale = 0
	#self.linear_velocity = Vector3(0, 0, 0)
	#self.rotation = Vector3.ZERO
	#self.lock_rotation = true
	for n in 20:
		await get_tree().create_timer(.025).timeout
		$splashRadius/GloopPart.set("blend_shapes/Key 1", (n * .05) - 1)
	await get_tree().create_timer(1).timeout
	for n in 200:
		await get_tree().create_timer(.001).timeout
		$splashRadius/GloopPart.set("blend_shapes/Key 1", (n * .005) )
		#self.position += Vector3(0, -.00125, 0)
	#await get_tree().create_timer(3).timeout
	done = true
	$".".queue_free()


func _on_splash_radius_body_entered(body):
	pass
	
	#print(body.name, "asijdhyuiasdghyuashd")
	
