extends Node3D

var isNear = false
var neverDoThisAgainOrElse = false
var canEnter = false
var n = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isNear:
		if Input.is_action_just_pressed("jump"):
			$portal/PortalGate.set("blend_shapes/UNLOCK", 1)
			for j in range(20):
				await get_tree().create_timer(.001).timeout
				$portal/PortalGate.set("blend_shapes/UNLOCK", n)
				n+=0.1
			$portal/Label3D.visible = false
			Globals.hasKey = false
			Globals.player.key()
			neverDoThisAgainOrElse = true
			canEnter = true

func _on_Area3D_entered(body):
	Globals.current_scene = "res://assets/Scenes/Level/Cave/cave.tscn"
	Globals.save()
	get_tree().change_scene_to_file("res://assets/Scenes/Level/Cave/cave.tscn")

func _on_portal_area_3d_body_entered(body):
	if neverDoThisAgainOrElse or not Globals.hasKey: return
	if body == Globals.player:
		$portal/Label3D.visible = true
		isNear = true
		
func _on_portal_area_3d_body_exited(body):
	if neverDoThisAgainOrElse or not Globals.hasKey: return
	if body == Globals.player:
		$portal/Label3D.visible = false
		isNear = false

func _on_teleport_area_3d_body_entered(body):
	if !canEnter or body != Globals.player: return
	Globals.current_scene = "res://assets/Scenes/Level/Canyon/canyon.tscn"
	Globals.save()
	get_tree().change_scene_to_file("res://assets/Scenes/Level/Canyon/canyon.tscn")



