extends RigidBody3D

@onready var blob = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_blob_body_entered(body):
	if body is CSGBox3D:
		print("Check Check")
		Globals.blobFired = false
