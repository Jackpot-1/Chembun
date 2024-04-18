extends Node

var slots = []
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
