extends Node

@export var Items: Array[InvItem]

#var slots = []
var scroll = false
var scrollAdder = 0

var currentItem = null

var downcool = false

#var itemClass = preload("res://assets/Miscellaneous/item.tscn")
@onready var slots: Array = [
	$Quarter/Path2D/PathFollow2D/Circle/Panel,
	$Quarter/Path2D/PathFollow2D2/Circle/Panel,
	$Quarter/Path2D/PathFollow2D3/Circle/Panel,
	$Quarter/Path2D/PathFollow2D4/Circle/Panel,
	$Quarter/Path2D/PathFollow2D5/Circle/Panel
]
#var zoom = 0 # this variable and the things that use it will make it so you can zoom with the scroll wheel

var path1 = .15
var path2 = .35
var path3 = .55
var path4 = .75
var path5 = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	slotUpdater()
	selectItem()
	#slots[1]["item"] = itemClass.instantiate()
	#slots[1]["item"].Image(Globals.items[1])
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#$CanvasLayer/hotbar/Quarter.set_value = val
	#if val != 25:
		#val += 1
		#cooldown(val)
	
	if scrollAdder == 0 and downcool == false: return
	elif downcool == true:
		var total_time = $cooldown.wait_time
		$Quarter.value = ((total_time - $cooldown.time_left)/total_time)*25
	elif scrollAdder == 0: return
	
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
	
	#print(path1, " path1")
	#print(path2, " path2")
	#print(path3, " path3")
	#print(path4, " path4")
	#print(path5, " path5")
	
	selectItem()
	
func selectItem():
	if path1 == 0 or path1 == 1:
		if Items[0] == null: $Quarter/bigItemDisplay.texture = null
		else: $Quarter/bigItemDisplay.texture = Items[0].big_texture
		currentItem = Items[0].name
		Globals.color = Items[0].color
	elif path2 == 0 or path2 == 1:
		if Items[1] == null: $Quarter/bigItemDisplay.texture = null
		else: $Quarter/bigItemDisplay.texture = Items[1].big_texture
		currentItem = Items[1].name
		Globals.color = Items[1].color
	elif path3 == 0 or path3 == 1:
		if Items[2] == null: $Quarter/bigItemDisplay.texture = null
		else: $Quarter/bigItemDisplay.texture = Items[2].big_texture
		currentItem = Items[2].name
		Globals.color = Items[2].color
	elif path4 == 0 or path4 == 1:
		if Items[3] == null: $Quarter/bigItemDisplay.texture = null
		else: $Quarter/bigItemDisplay.texture = Items[3].big_texture
		currentItem = Items[3].name
		Globals.color = Items[3].color
	elif path5 == 0 or path5 == 1:
		if Items[4] == null: $Quarter/bigItemDisplay.texture = null
		else: $Quarter/bigItemDisplay.texture = Items[4].big_texture
		currentItem = Items[4].name
		Globals.color = Items[4].color
	Globals.currItem = currentItem

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
	if Items[0].name == "":
		Items[0] = item
	elif Items[1].name == "":
		Items[1] = item
	elif Items[2].name == "":
		Items[2] = item
	elif Items[3].name == "":
		Items[3] = item
	elif Items[4].name == "":
		Items[4] = item
	slotUpdater()
		
		
	
#func _on_timer_timeout():
	#if scroll == false:
		#scrollAdder = 0

func cooldown():
	downcool = true
	$cooldown.start()


func _on_cooldown_timeout():
	
	downcool = false
	Globals.blobFired = false
	#Globals.blobReady = true
