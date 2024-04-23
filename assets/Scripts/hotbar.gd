extends Node

var slots = []
var scroll = false
var scrollAdder = 0

var path1 = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	slots = [
		{
			"position" : $HBoxContainer/Control/Panel.position,
			"item" : null
		},
		{
			"position" : $HBoxContainer/Control/Panel2.position,
			"item" : null
		},
		{
			"position" : $HBoxContainer/Control/Panel3.position,
			"item" : null
		},
		{
			"position" : $HBoxContainer/Control/Panel4.position,
			"item" : null
		},
		{
			"position" : $HBoxContainer/Control/Panel5.position,
			"item" : null
		}
	]
	
	


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
	
		
	if path1 <= 0.21 and path1 >= 0.19 or path1 <= 0.41 and path1 >= 0.39 or path1 <= 0.61 and path1 >= 0.59 or path1 <= 0.81 and path1 >= 0.79 or path1 <= 0.1 and path1 >= 0.99 or path1 == 1 or path1 == 0:
		scrollAdder = 0
		print(path1, " yes")
	else: print(path1, " no")


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			scroll = true
			scrollAdder = 0.05
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			scroll = true
			scrollAdder = -0.05
			
func slot_mover():
	pass
	
func slotUpdater(item):
	if slots[0]["item"] == null:
		slots[0]["item"] = item
		# draw the item to the slot here
	elif slots[1]["item"] == null:
		slots[1]["item"] = item
		# draw the item to the slot here
	elif slots[2]["item"] == null:
		slots[2]["item"] = item
		# draw the item to the slot here
	elif slots[3]["item"] == null:
		slots[3]["item"] = item
		# draw the item to the slot here
	elif slots[4]["item"] == null:
		slots[4]["item"] = item
		# draw the item to the slot here
		
	
#func _on_timer_timeout():
	#if scroll == false:
		#scrollAdder = 0
		
