extends CanvasLayer

var playerStopped = false
var ispaused = false
var isinventory = false
var iselement = false

var dialogueChek = Globals.dialogueChek

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.GUI = $"."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func stop_player_input():
	playerStopped = true
	DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE) # unhides the mouse and lets it move
	$"../ChemBun/Camroot".process_mode = Node.PROCESS_MODE_DISABLED
	$"../ChemBun/CamRightTank".process_mode = Node.PROCESS_MODE_DISABLED
func unstop_player_input():
	playerStopped = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # hides the mouse and makes it so it can't move
	$"../ChemBun/Camroot".process_mode = Node.PROCESS_MODE_INHERIT
	$"../ChemBun/CamRightTank".process_mode = Node.PROCESS_MODE_INHERIT

func _input(event):
	if event.is_action_pressed("menu"):
			if ispaused == false:
				get_tree().paused = true # set process mode to "Always" so you can unpause
				ispaused = true
				stop_player_input()
			else:
				get_tree().paused = false
				ispaused = false
				unstop_player_input()
	#elif event.is_action_pressed("inventory"):
		#if isinventory == false && playerStopped == false:
			#$InventoryGridTransfer.visible = true
			#isinventory = true
			#stop_player_input()
			#
		#else:
			#$InventoryGridTransfer.visible = false
			#isinventory = false
			#unstop_player_input()
			
	if event.is_action_pressed("element") && playerStopped == false:
		iselement = true
		$Control.visible = true
		stop_player_input()
	elif event.is_action_released("element") && iselement == true && playerStopped == true:
		iselement = false
		$Control.recipe = ""
		$Control/VBoxContainer/RichTextLabel.text = ""
		$Control.visible = false
		unstop_player_input()

func dialogue(Character, OgText, Repetable, RepeatableText, FinishedText, time):
	if dialogueChek[Character]["Finished"]: return
	$ChemBox.visible = true
	if not dialogueChek[Character]["FirstRun"]:
		$ChemBox/ChemText.text = OgText
		dialogueChek[Character]["FirstRun"] = true
	elif Repetable:
		$ChemBox/ChemText.text = RepeatableText
		dialogueChek[Character]["Repeatable"] = true
	elif dialogueChek[Character]["Key"]:
		$ChemBox/ChemText.text = FinishedText
		dialogueChek[Character]["Finished"] = true
	else:
		dialogueChek[Character]["Finished"] = true
	await get_tree().create_timer(time).timeout
	$ChemBox.visible = false
