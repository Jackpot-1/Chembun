extends Node

var slots = []
var scroll = false
var scrollAdder = 0

var path1 = 0
var path2 = 0
var path3 = 0
var path4 = 0
var path5 = 0
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
	
	# need this because floating intager math is bad
	$Quarter/Path2D/PathFollow2D.set_progress_ratio(snappedf($Quarter/Path2D/PathFollow2D.get_progress_ratio(), 0.01))
	$Quarter/Path2D/PathFollow2D2.set_progress_ratio(snappedf($Quarter/Path2D/PathFollow2D2.get_progress_ratio(), 0.01))
	$Quarter/Path2D/PathFollow2D3.set_progress_ratio(snappedf($Quarter/Path2D/PathFollow2D3.get_progress_ratio(), 0.01))
	$Quarter/Path2D/PathFollow2D4.set_progress_ratio(snappedf($Quarter/Path2D/PathFollow2D4.get_progress_ratio(), 0.01))
	$Quarter/Path2D/PathFollow2D5.set_progress_ratio(snappedf($Quarter/Path2D/PathFollow2D5.get_progress_ratio(), 0.01))
	
	path1 = snappedf($Quarter/Path2D/PathFollow2D.get_progress_ratio(), 0.01)
	path2 = snappedf($Quarter/Path2D/PathFollow2D2.get_progress_ratio(), 0.01)
	path3 = snappedf($Quarter/Path2D/PathFollow2D3.get_progress_ratio(), 0.01)
	path4 = snappedf($Quarter/Path2D/PathFollow2D4.get_progress_ratio(), 0.01)
	path5 = snappedf($Quarter/Path2D/PathFollow2D5.get_progress_ratio(), 0.01)
	

	
	if $Quarter/Path2D/PathFollow2D.progress_ratio == 0.15 or $Quarter/Path2D/PathFollow2D.progress_ratio == 0.35 or $Quarter/Path2D/PathFollow2D.progress_ratio == 0.55 or $Quarter/Path2D/PathFollow2D.progress_ratio == 0.75 or $Quarter/Path2D/PathFollow2D.progress_ratio == 0.95:
		scrollAdder = 0
		print($Quarter/Path2D/PathFollow2D.progress_ratio, " yes")
	else: print($Quarter/Path2D/PathFollow2D.progress_ratio, " no")
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			scroll = true
			scrollAdder = 0.05
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			scroll = true
			scrollAdder = -0.05
	
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
		
