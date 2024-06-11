extends Node3D

var isNear = false
var inWater = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_asteroid_hitbox_area_entered(area):
	if area.name != "explosion": return
	if area.get_parent().Name == "Mercury(II) Fulminate":
		$"NavigationRegion3D/Canyon Mesh/Asteroid".queue_free()

func _on_chembox_tx_t_area_3d_body_entered(body):
	if body == Globals.player:
		Globals.GUI.dialogue("CanyonSign", "Maybe this Compound will help me clear this asteroid.", false, "", "", 3)
		#$Sign/Label3D.visible = true
		isNear = true


func _on_ost_canyon_finished():
	$"OST-Canyon".play()


func _on_area_3d_body_entered(body):
	if body != Globals.player: return
	AudioServer.set_bus_effect_enabled(0, 0, true)
	AudioServer.set_bus_effect_enabled(0, 1, true)
	$ChemBun.gravity = 7
	$ChemBun.walk_speed = 3.5
	$ChemBun.knockback.x = 3

func _on_area_3d_body_exited(body):
	if body != Globals.player: return
	AudioServer.set_bus_effect_enabled(0, 0, false)
	AudioServer.set_bus_effect_enabled(0, 1, false)
	$ChemBun.gravity = 9.8
	$ChemBun.walk_speed = 4
	$ChemBun.run_speed = 6
	$ChemBun.knockback.x = 0


func _on_area_3d_area_entered(area):
	if area.name == "CamrootArea3d": $CanvasLayer/WaterOverlay.visible = true


func _on_area_3d_area_exited(area):
	if area.name == "CamrootArea3d": $CanvasLayer/WaterOverlay.visible = false
