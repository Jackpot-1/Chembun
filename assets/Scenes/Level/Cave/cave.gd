extends Node3D

var n = 0
var isNear = false
var neverDoThisAgainOrElse = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#$ChestBody3D.freeze = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("skip"):
		$SaltBody3D/Salt.set("blend_shapes/Done", n)
		$SaltBody3D/CollisionShape3D.position.y -= 0.1
		n += 0.06
	if isNear:
		if Input.is_action_just_pressed("jump"):
			$ChestBody3D/Chest.set("blend_shapes/Key 1", 1)
			$ChestBody3D/Label3D.visible = false
			Globals.hasKey = true
			Globals.current_scene = "res://assets/Scenes/Level/Overworld/overworld.tscn"
			Globals.save()
			get_tree().change_scene_to_file("res://assets/Scenes/Level/Overworld/overworld.tscn")
			neverDoThisAgainOrElse = true

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
