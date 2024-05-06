extends Node

@export var Items: Array[InvItem]

#var slots = []
var scroll = false
var scrollAdder = 0
#var itemClass = preload("res://assets/Miscellaneous/item.tscn")
@onready var slots: Array = [
	$Quarter/Path2D/PathFollow2D/Circle/Panel,
	$Quarter/Path2D/PathFollow2D2/Circle/Panel,
	$Quarter/Path2D/PathFollow2D3/Circle/Panel,
	$Quarter/Path2D/PathFollow2D4/Circle/Panel,
	$Quarter/Path2D/PathFollow2D5/Circle/Panel
]
#var zoom = 0 # this variable and the things that use it will make it so you can zoom with the scroll wheel

var path1 = 0
var path2 = 0
var path3 = 0
var path4 = 0
var path5 = 0

var currentItem = null
# Called when the node enters the scene tree for the first time.
func _ready():
	slotUpdater()
	#slots[1]["item"] = itemClass.instantiate()
	#slots[1]["item"].Image(Globals.items[1])
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if scrollAdder == 0: return
	
	$Quarter/Path2D/PathFollow2D.progress_ratio += scrollAdder
	$Quarter/Path2D/PathFollow2D2.progress_ratio += scrollAdder
	$Quarter/Path2D/PathFollow2D3.progress_ratio += scrollAdder
	$Quarter/Path2D/PathFollow2D4.progress_ratio += scrollAdder
	$Quarter/Path2D/PathFollow2D5.progress_ratio += scrollAdder
	
	#$Quarter/Path2D/PathFollow2D.set_progress_ratio(snappedf($Quarter/Path2D/PathFollow2D.get_progress_ratio() + scrollAdder, 0.05))
	#$Quarter/Path2D/PathFollow2D2.progress_ratio = snappedf($Quarter/Path2D/PathFollow2D2.get_progress_ratio() + scrollAdder, 0.05)
	#$Quarter/Path2D/PathFollow2D3.set_progress_ratio(snappedf($Quarter/Path2D/PathFollow2D3.progress_ratio + scrollAdder, 0.05))
	#$Quarter/Path2D/PathFollow2D4.set_progress_ratio(snappedf($Quarter/Path2D/PathFollow2D4.progress_ratio + scrollAdder, 0.05))
	#$Quarter/Path2D/PathFollow2D5.set_progress_ratio(snappedf($Quarter/Path2D/PathFollow2D5.progress_ratio + scrollAdder, 0.05))

	# need this because floating intager math is bad
	$Quarter/Path2D/PathFollow2D.progress_ratio = snappedf($Quarter/Path2D/PathFollow2D.get_progress_ratio(), 0.05)
	$Quarter/Path2D/PathFollow2D2.progress_ratio = snappedf($Quarter/Path2D/PathFollow2D2.get_progress_ratio(), 0.05)
	$Quarter/Path2D/PathFollow2D3.progress_ratio = snappedf($Quarter/Path2D/PathFollow2D3.get_progress_ratio(), 0.05)
	$Quarter/Path2D/PathFollow2D4.progress_ratio = snappedf($Quarter/Path2D/PathFollow2D4.get_progress_ratio(), 0.05)
	$Quarter/Path2D/PathFollow2D5.progress_ratio = snappedf($Quarter/Path2D/PathFollow2D5.get_progress_ratio(), 0.05)
	
	path1 = $Quarter/Path2D/PathFollow2D.get_progress_ratio()
	path2 = $Quarter/Path2D/PathFollow2D2.get_progress_ratio()
	path3 = $Quarter/Path2D/PathFollow2D3.get_progress_ratio()
	path4 = $Quarter/Path2D/PathFollow2D4.get_progress_ratio()
	path5 = $Quarter/Path2D/PathFollow2D5.get_progress_ratio()
	
	# I'm sorry
	if path1 <= 0.21 and path1 >= 0.19 or path1 <= 0.41 and path1 >= 0.39 or path1 <= 0.61 and path1 >= 0.59 or path1 <= 0.81 and path1 >= 0.79 or path1 <= 0.1 and path1 >= 0.99 or path1 == 1 or path1 == 0:
		scrollAdder = 0
		#print(path1, " yes")
	#else: print(path1, " no")
	
	print(path1, " path1")
	print(path2, " path2")
	print(path3, " path3")
	print(path4, " path4")
	print(path5, " path5")
	if path1 == 0 or path1 == 1:
		if Items[0] == null: $Quarter/bigItemDisplay.texture = null
		else: 
			$Quarter/bigItemDisplay.texture = Items[0].big_texture
			currentItem = Items[0].name
	elif path2 == 0 or path2 == 1:
		if Items[1] == null: $Quarter/bigItemDisplay.texture = null
		else:
			$Quarter/bigItemDisplay.texture = Items[1].big_texture
			currentItem = Items[1].name
	elif path3 == 0 or path3 == 1:
		if Items[2] == null: $Quarter/bigItemDisplay.texture = null
		else:
			$Quarter/bigItemDisplay.texture = Items[2].big_texture
			currentItem = Items[2].name
	elif path4 == 0 or path4 == 1:
		if Items[3] == null: $Quarter/bigItemDisplay.texture = null
		else:
			$Quarter/bigItemDisplay.texture = Items[3].big_texture
			currentItem = Items[3].name
	elif path5 == 0 or path5 == 1:
		if Items[4] == null: $Quarter/bigItemDisplay.texture = null
		else:
			$Quarter/bigItemDisplay.texture = Items[4].big_texture
			currentItem = Items[4].name
	Globals.itemName = currentItem
	Globals.testing()
	


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			scroll = true
			scrollAdder = 0.05
			#zoom += 0.1
			#$"../../PlayerTemplate/Camroot".zoom_set($"../../PlayerTemplate/Camroot".zoom_get()+zoom)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			scroll = true
			scrollAdder = -0.05
			#zoom -= 0.1
			#$"../../PlayerTemplate/Camroot".zoom_set($"../../PlayerTemplate/Camroot".zoom_get()+zoom)
			
func selectedSlot(item):
	if item == null: return
	
func slotUpdater():
	for i in range(min(Items.size(), slots.size())):
		slots[i].update(Items[i])
	
		
func slotInserter(item:InvItem):
	if Items[0] == null:
		Items[0] = item
	elif Items[1] == null:
		Items[1] = item
	elif Items[2] == null:
		Items[2] = item
	elif Items[3] == null:
		Items[3] = item
	elif Items[4] == null:
		Items[4] = item
	slotUpdater()
		
		
	
#func _on_timer_timeout():
	#if scroll == false:
		#scrollAdder = 0
		
	
	
func _on_area_2d_body_entered(body):
	print(body, " entered")
	



func _on_area_2d_body_exited(body):
	print(body, " exited")
