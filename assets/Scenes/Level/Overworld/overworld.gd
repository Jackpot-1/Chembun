extends Node3D

var isNear = false
var neverDoThisAgainOrElse = false
var canEnter = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isNear:
		if Input.is_action_just_pressed("jump"):
			$portal/PortalGate.set("blend_shapes/UNLOCK", 1)
			$portal/Label3D.visible = false
			neverDoThisAgainOrElse = true
			canEnter = true


func _on_static_body_3d_body_entered(body):
	get_tree().change_scene_to_file("res://assets/Scenes/Level/Cave/cave.tscn")
	Globals.current_scene = "res://assets/Scenes/Level/Cave/cave.tscn"
	Globals.save()


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
