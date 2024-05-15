extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_asteroid_hitbox_area_entered(area):
	if area.name != "explosion": return
	#print(area.get("metadata/name"), " HELLLP - HELP ME")
	print(area.get_parent().Name, " HELLLP - HELP ME")
	if area.get_parent().Name == "Mercury(II) Fulminate":
		$"Canyon Mesh/Asteroid".queue_free()
