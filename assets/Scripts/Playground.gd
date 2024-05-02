extends Node3D


func _enter_tree():
	if Checkpoints.last_position:
		$PlayerTemplate.global_position = Checkpoints.last_position
func _ready():
	#this takes a string from globals and converts it into a function
	print("From the north")
	$CanvasLayer/hotbar
	#var data = Globals.add_item(Globals.items[0])
	#Expression.new().parse("print(" + data[0] + ".add_item2(data[1]))")
	#$CanvasLayer/hotbar/Quarter/Path2D/PathFollow2D/Circle/Panel.add_item2(data[1])
	#Expression.new().parse(Globals.add_item(Globals.items)[0].Globals.add_item(Globals.items)[1])
	#var panel = get_node(Globals.add_item(Globals.items[0]))
	#panel.add_item2(image)
	#.add_item2(image)
	
