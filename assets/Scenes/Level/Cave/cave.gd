extends Node3D

var n = 0
var t = 0
var p = 0
var isNear = false
var neverDoThisAgainOrElse = false
var openChest = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#$ChestBody3D.freeze = false
	if Globals.hasKey or Globals.gateOpen:
		$ChestBody3D/Chest.set("blend_shapes/Key 1", 1)
		neverDoThisAgainOrElse = true
		$SaltBody3D/Salt.set("blend_shapes/Done", 1)
		$ChestBody3D.position.y = 23.7
		$SaltBody3D/CollisionShape3D.position.y = -1
		$SaltBody3D/SaltHitBox/CollisionShape3D.position.y = -1
		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isNear:
		if Input.is_action_just_pressed("jump"):
			openChest = true
	if openChest:
		if p < 1:
			p+=0.1
			$ChestBody3D/Chest.set("blend_shapes/Key 1", p)
		$ChestBody3D/Label3D.visible = false
		$ChestBody3D/Keys.visible = true
		t+=delta * 0.05
		$ChestBody3D/Keys.transform = $ChestBody3D/Keys.transform.interpolate_with($ChestBody3D/Marker3D.transform, t)
		
		neverDoThisAgainOrElse = true
	if Globals.hasKey or Globals.gateOpen:
		$Label.visible = true
		if Input.is_action_just_pressed("jump"):
			Globals.position = Vector3(-14.262, 12.509, -54.035)
			Globals.current_scene = "res://assets/Scenes/Level/Overworld/overworld.tscn"
			Globals.save()
			get_tree().change_scene_to_file("res://assets/Scenes/Level/Overworld/overworld.tscn")

func _on_area_3d_body_entered(body):
	if neverDoThisAgainOrElse: return
	if body == Globals.player:
		$ChestBody3D/Label3D.visible = true
		isNear = true
	

func _on_area_3d_body_exited(body):
	if neverDoThisAgainOrElse: return
	if body == Globals.player:
		$ChestBody3D/Label3D.visible = false
		isNear = false


func _on_salt_hit_box_area_entered(area):
	if area.name != "splashRadius": return
	#print(area.get("metadata/name"), " HELLLP - HELP ME")
	print(area.get_parent().Name, " HELLLP - HELP ME")
	if area.get_parent().Name == "Water":
		for j in range(20):
			await get_tree().create_timer(.001).timeout
			$SaltBody3D/CollisionShape3D.position.y -= 0.0165
			$SaltBody3D/SaltHitBox/CollisionShape3D.position.y -= 0.0165
			$SaltBody3D/Salt.set("blend_shapes/Done", n)
			n+=0.01
		


func _on_key_area_3d_body_entered(body):
	if body != Globals.player: return
	$ChestBody3D/Keys.visible = false
	Globals.hasKey = true
	Globals.player.key()
	Globals.dialogueChek["Door"]["Key"] = true
	Globals.position = Vector3(-14.262, 12.509, -54.035)
	Globals.current_scene = "res://assets/Scenes/Level/Overworld/overworld.tscn"
	Globals.save()
	
