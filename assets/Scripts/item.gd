extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#$TextureRect.texture = load("res://assets/images/items/ccarrot.png")
	pass


func Image(image):
	print("to the west")
	#$TextureRect.texture = load(image)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
