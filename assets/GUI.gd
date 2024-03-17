extends CanvasLayer

var ispaused = false
var isinventory = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("menu"):
			if ispaused == false:
				get_tree().paused = true # set process mode to "Always" so you can unpause
				ispaused = true
			else:
				get_tree().paused = false
				ispaused = false
	elif event.is_action_pressed("inventory"):
		if isinventory == false:
			$InventoryGridTransfer.visible = true
			isinventory = true
			DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE) # unhides the mouse and lets it move
			$"../PlayerTemplate/Camroot".process_mode = Node.PROCESS_MODE_DISABLED
			
		else:
			$InventoryGridTransfer.visible = false
			isinventory = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # hides the mouse and makes it so it can't move
			$"../PlayerTemplate/Camroot".process_mode = Node.PROCESS_MODE_INHERIT
