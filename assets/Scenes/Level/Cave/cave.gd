extends Node3D

var t = 0
var p = 0
var isNear = false
var neverDoThisAgainOrElse = false
var openChest = false

var TxTCheckCaveEnter = false
var TxTCheckCaveMid = false

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
		#$ChestBody3D/Keys.visible = true
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
			$SaltBody3D/Salt.set("blend_shapes/Done", $SaltBody3D/Salt.get("blend_shapes/Done")+0.01)


func _on_key_area_3d_body_entered(body):
	if body != Globals.player: return
	$ChestBody3D/Keys.visible = false
	print($ChestBody3D/Keys.visible)
	Globals.hasKey = true
	Globals.player.key()
	Globals.dialogueChek["Door"]["Key"] = true
	Globals.GUI.dialogue("Chess", "A key! I wonder what this could go to...", false, "", "", 8)
	Globals.position = Vector3(-14.262, 12.509, -54.035)
	Globals.current_scene = "res://assets/Scenes/Level/Overworld/overworld.tscn"
	Globals.save()
	


func _on_cave_enter_area_3d_body_entered(body):
	if body == Globals.player and not TxTCheckCaveEnter:
		Globals.GUI.dialogue("CaveEnter", "Huh, those salt creatures look to not be too friendly. Well-Salt is soluble in water right?", false, "", "", 8)
		TxTCheckCaveEnter = true


func _on_cave_mid_area_3d_body_entered(body):
	if body == Globals.player and not TxTCheckCaveMid:
		Globals.GUI.dialogue("CaveMid", "Alright, Now if only I could find a way to get this chest down from this big pile of salt.", false, "", "", 8)
		TxTCheckCaveMid = true


func _on_ost_cave_finished():
	$"OST-Cave".play()


# extra_arg_0 is a string with the parent node name. eg: salt1, salt2...
func _on_area_3d_area_entered(area, extra_arg_0):
	if area.name != "splashRadius": return
	if area.get_parent().Name == "Water":
		var parent_node = get_node(extra_arg_0) #salt1, salt2, salt3...
		var pile = parent_node.get_node("pile") #the salt pile 3D mesh
		var staticbody3d = parent_node.get_node("StaticBody3D")
		var area3d = parent_node.get_node("Area3D")
		for j in range(50):
			await get_tree().create_timer(.0005).timeout
			staticbody3d.position.y -= 0.05
			area3d.position.y -= 0.05
			pile.set("blend_shapes/Done", pile.get("blend_shapes/Done")+0.01)
			#if snappedf(pile.get("blend_shapes/Done"), 0.1) >= 1: staticbody3d.free(); area3d.free(); return # yes, yes, I know how to combine lines, now bow down to me.
		

