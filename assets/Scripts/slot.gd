extends Node

var ItemClass = preload("res://assets/Miscellaneous/item.tscn")
var item = null
# Called when the node enters the scene tree for the first time.
func _ready():
	if randi() % 2 == 0:
		item = ItemClass.instantiate()
		add_child(item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
