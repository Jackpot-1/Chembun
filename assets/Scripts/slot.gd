extends Node

var ItemClass = preload("res://assets/Miscellaneous/item.tscn")
var item = null
@onready var item_visual: Sprite2D = $itemDisplay
# Called when the node enters the scene tree for the first time.
func _ready():
	#if randi() % 2 == 0:
		#item = ItemClass.instantiate()
		#add_child(item)
	pass
	
func update(item:InvItem):
	print(item)
	if !item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = item.texture
		
func insert(item:InvItem):
	pass

#func add_item2(image):
	#print("to the east")
	#item = ItemClass.instantiate()
	#item.Image(image)
	#add_child(item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
