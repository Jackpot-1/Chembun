extends Node3D

var isNear = false
var neverDoThisAgainOrElse = false
var TxTCheckHouse = false
var TxTCHeckCaveHole = false
var n = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.player.position = Globals.position
	if Globals.gateOpen:
		$portal/PortalGate.set("blend_shapes/UNLOCK", 1)
		$"portal/PortalGate/portal collision/StaticBody3D/CollisionShape3D".disabled = true
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isNear and not neverDoThisAgainOrElse:
		if Input.is_action_just_pressed("jump"):
			Globals.hasKey = false
			Globals.player.key()
			print("Testing stuff")
			#Globals.GUI.dialogue("Door", "", false, "", "This should fit!", 5)
			$portal/PortalGate.set("blend_shapes/UNLOCK", 1)
			for j in range(100):
				await get_tree().create_timer(.001).timeout
				$portal/PortalGate.set("blend_shapes/UNLOCK", n)
				n+=0.01
			$"portal/PortalGate/portal collision/StaticBody3D/CollisionShape3D".disabled = true
			$portal/Label3D.visible = false
			Globals.gateOpen = true
			Globals.save()
			

func _on_Area3D_entered(body):
	Globals.current_scene = "res://assets/Scenes/Level/Cave/cave.tscn"
	Globals.save()
	get_tree().change_scene_to_file("res://assets/Scenes/Level/Cave/cave.tscn")

func _on_portal_area_3d_body_entered(body):
	print("Entered")
	if neverDoThisAgainOrElse: return
	if not Globals.hasKey and body == Globals.player:
		Globals.GUI.dialogue("Door", "I need something to open this", true, "still need that key huh..", "This should fit!", 5)
		return
	if body == Globals.player:
		Globals.GUI.dialogue("Door", "This should fit!", false, "still need that key huh..", "This should fit!", 5)
		$portal/Label3D.visible = true
		isNear = true
		
func _on_portal_area_3d_body_exited(body):
	if neverDoThisAgainOrElse or not Globals.hasKey: return
	if body == Globals.player:
		$portal/Label3D.visible = false
		isNear = false

func _on_teleport_area_3d_body_entered(body):
	if !Globals.gateOpen or body != Globals.player: return
	Globals.PortalWoosh = true
	Globals.current_scene = "res://assets/Scenes/Level/Map_Select/Level_Select.tscn"
	Globals.save()
	get_tree().change_scene_to_file("res://assets/Scenes/Level/Map_Select/Level_Select.tscn")
	#get_tree().change_scene_to_file("res://assets/Scenes/Level/Canyon/canyon.tscn")

# v TxT Area v

func _on_house_tx_t_area_3d_body_entered(body):
	if body == Globals.player and not TxTCheckHouse:
		Globals.GUI.dialogue("ChemHouseExit", "I better go to the cave like that mysterious fella was telling me", false, "", "", 6)
		TxTCheckHouse = true


func _on_ost_overworld_finished():
	$"OST-Overworld".play()


func _on_cave_hole_tx_t_area_3d_body_entered(body):
	if body == Globals.player and not TxTCHeckCaveHole:
		Globals.GUI.dialogue("CaveHole", "Hmm, where does this hole lead?", false, "", "", 4)
		TxTCHeckCaveHole = true


func _on_audio_stream_player_3d_finished():
	$portal/PortalGate/Portal.play()
