extends Control

var isListening = false
var changeTo = null #the string to change to in the gui
var eventTo = null # the event to change to in the input manager
var keyName = ""
var whatItWasBefore = ""


@onready var keyDict = {
	"forward" : $TabContainer/Controls/ScrollContainer/MarginContainer/GridContainer/ForwardButton/GridContainer,
	"left" : $TabContainer/Controls/ScrollContainer/MarginContainer/GridContainer/LeftButton/GridContainer,
	"back" : $TabContainer/Controls/ScrollContainer/MarginContainer/GridContainer/BackButton/GridContainer,
	"right" : $TabContainer/Controls/ScrollContainer/MarginContainer/GridContainer/RightButton/GridContainer,
	"jump" : $TabContainer/Controls/ScrollContainer/MarginContainer/GridContainer/JumpButton/GridContainer,
	"sprint" : $TabContainer/Controls/ScrollContainer/MarginContainer/GridContainer/ShiftButton/GridContainer,
	"element" : $TabContainer/Controls/ScrollContainer/MarginContainer/GridContainer/ElementButton/GridContainer,
	"aim" : $TabContainer/Controls/ScrollContainer/MarginContainer/GridContainer/AimButton/GridContainer,
	"throw" : $TabContainer/Controls/ScrollContainer/MarginContainer/GridContainer/ThrowButton/GridContainer
}

var inputEventDict = { # for converting the current keys to the actual input names.
	"forward" : "forward",
	"left" : "left",
	"back" : "backward",
	"right" : "right",
	"jump" : "jump",
	"sprint" : "sprint",
	"element" : "element",
	"aim" : "aim",
	"throw" : "attack"
}

const defaultKeyDict = {
	"forward" : KEY_W,
	"left" : KEY_A,
	"backward" : KEY_S,
	"right" : KEY_D,
	"jump" : KEY_SPACE,
	"sprint" : KEY_SHIFT,
	"element" : KEY_ALT,
	"aim" : MOUSE_BUTTON_RIGHT,
	"attack" : MOUSE_BUTTON_LEFT
}

# Called when the node enters the scene tree for the first time.
func _ready():
	keyDict["forward"].grab_focus()
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN: $TabContainer/General/MarginContainer/GridContainer/HBoxContainer5/CheckButton.button_pressed = true
	#check if the controls are set to default
	if Globals.editableKeys != Globals.defaultKeys:
		for key in Globals.defaultKeys:
			if Globals.editableKeys[key] != Globals.defaultKeys[key]:
				add_reset_button(key)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if !isListening: return
	if event is InputEventMouseMotion: return
	if event.is_released(): return
	#if event.is_action("menu"):
		#isListening = false
		#changeTo = "escape"
		#return
	if event is InputEventMouseButton: # if you click on the button, then immediately click to set the input to left click, it becomes a double click
		event.double_click = false # this fixes that ^
	print(event)
	eventTo = event
	if event.as_text() == "Left Mouse Button":
		changeTo = "Left Click"
	elif event.as_text() == "Right Mouse Button":
		changeTo = "Right Click"
	else: changeTo = event.as_text()
	isListening = false
	change_input()
	
	
func add_reset_button(key):
	keyDict[key].columns = 3
	keyDict[key].get_node("reset").visible = true
	
func hide_reset_button(key):
	keyDict[key].columns = 2
	keyDict[key].get_node("reset").visible = false
	
func change_input(): # the function that all the input buttons get routed too
	if changeTo == null:
		keyDict[keyName].get_parent().disabled = true # if you don't disable it, you won't be able to use "enter" and "space" because that would select the button again
		isListening = true
		whatItWasBefore = keyDict[keyName].get_node("input").text
		keyDict[keyName].get_node("input").text = "_"
	else:
		if changeTo == "Escape":
			#keyDict[keyName].get_node("input").text = ""
			keyDict[keyName].get_parent().set_deferred("disabled", false)
			keyDict[keyName].get_node("input").text = whatItWasBefore
			return
		keyDict[keyName].get_parent().set_deferred("disabled", false)
		keyDict[keyName].get_node("input").text = changeTo
		Globals.editableKeys[keyName] = changeTo
		
		InputMap.action_erase_events(inputEventDict[keyName])
		InputMap.action_add_event(inputEventDict[keyName], eventTo)
		
		if changeTo == Globals.defaultKeys[keyName]:
			if keyDict[keyName].columns != 2: # if its not 2, that means that the reset button is already there as set in add_reset_button()
				hide_reset_button(keyName)
		else:
			if keyDict[keyName].columns != 3: # if its not 3, that means that the reset button is already hidden as set in hide_reset_button()
				add_reset_button(keyName)
		changeTo = null
		
func reset(key): # the function that all the reset buttons get routed too
	hide_reset_button(key)
	keyDict[key].get_node("input").text = Globals.defaultKeys[key]
	Globals.editableKeys[key] = Globals.defaultKeys[key]
	var new_input = InputEventKey.new()
	InputMap.action_erase_events(inputEventDict[key])
	new_input.keycode = defaultKeyDict[inputEventDict[key]]
	InputMap.action_add_event(inputEventDict[key], new_input)

func _on_forward_button_pressed():
	keyName = "forward"
	change_input()


func _on_reset_forward_pressed():
	reset("forward")


func _on_left_button_pressed():
	keyName = "left"
	change_input()


func _on_reset_left_pressed():
	reset("left")


func _on_back_button_pressed():
	keyName = "back"
	change_input()


func _on_reset_back_pressed():
	reset("back")


func _on_right_button_pressed():
	keyName = "right"
	change_input()


func _on_reset_right_pressed():
	reset("right")


func _on_jump_button_pressed():
	keyName = "jump"
	change_input()


func _on_reset_jump_pressed():
	reset("jump")


func _on_shift_button_pressed():
	keyName = "sprint"
	change_input()


func _on_reset_shift_pressed():
	reset("sprint")


func _on_element_button_pressed():
	keyName = "element"
	change_input()


func _on_reset_element_pressed():
	reset("element")


func _on_aim_button_pressed():
	keyName = "aim"
	change_input()


func _on_reset_aim_pressed():
	reset("aim")


func _on_throw_button_pressed():
	keyName = "throw"
	change_input()


func _on_reset_throw_pressed():
	reset("throw")


func _on_h_slider_music_value_changed(value):
	print(AudioServer.bus_count)
	$TabContainer/General/MarginContainer/GridContainer/HBoxContainer/Label.text = str(value)
	if value == 25: $TabContainer/General/MarginContainer/GridContainer/HBoxContainer/reset.visible = false
	else: $TabContainer/General/MarginContainer/GridContainer/HBoxContainer/reset.visible = true
	
	value /= 100
	
	#value*=0.56 # the audio busses go from -80 to 6 db
	#value-=50
	##if value < -60: value = 0
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_reset_music_pressed():
	$TabContainer/General/MarginContainer/GridContainer/HBoxContainer/reset.visible = false
	$TabContainer/General/MarginContainer/GridContainer/HBoxContainer/HSlider.value = 25


func _on_h_slider_sfx_value_changed(value):
	$TabContainer/General/MarginContainer/GridContainer/HBoxContainer2/Label.text = str(value)
	if value == 25: $TabContainer/General/MarginContainer/GridContainer/HBoxContainer2/reset.visible = false
	else: $TabContainer/General/MarginContainer/GridContainer/HBoxContainer2/reset.visible = true
	
	value /= 100
	
	#value*=0.56 # the audio busses go from -80 to 6 db
	#value-=50
	#if value < -60: value = 0
	AudioServer.set_bus_volume_db(2, linear_to_db(value))


func _on_reset_sfx_pressed():
	$TabContainer/General/MarginContainer/GridContainer/HBoxContainer2/reset.visible = false
	$TabContainer/General/MarginContainer/GridContainer/HBoxContainer2/HSlider.value = 25


func _on_h_slider_fov_value_changed(value):
	$TabContainer/General/MarginContainer/GridContainer/HBoxContainer3/Label.text = str(value)
	if value == 10: $TabContainer/General/MarginContainer/GridContainer/HBoxContainer3/reset.visible = false
	else: $TabContainer/General/MarginContainer/GridContainer/HBoxContainer3/reset.visible = true
	value /= 2
	value-=5
	Globals.zoom(value)


func _on_reset_fov_pressed():
	$TabContainer/General/MarginContainer/GridContainer/HBoxContainer3/reset.visible = false
	$TabContainer/General/MarginContainer/GridContainer/HBoxContainer3/HSlider.value = 10


func _on_exit_pressed():
	get_tree().paused = false
	Globals.save()
	get_tree().change_scene_to_file("res://assets/Scenes/Screens/MainMenuScreen.tscn")


func _on_h_slider_sensitivity_value_changed(value):
	$TabContainer/General/MarginContainer/GridContainer/HBoxContainer4/Label.text = str(value)
	if value == 50: $TabContainer/General/MarginContainer/GridContainer/HBoxContainer4/reset.visible = false
	else: $TabContainer/General/MarginContainer/GridContainer/HBoxContainer4/reset.visible = true
	value /= 5000
	Globals.sensi(value)


func _on_reset_sensitivity_pressed():
	$TabContainer/General/MarginContainer/GridContainer/HBoxContainer4/reset.visible = false
	$TabContainer/General/MarginContainer/GridContainer/HBoxContainer4/HSlider.value = 50


func _on_check_button_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		$TabContainer/General/MarginContainer/GridContainer/HBoxContainer5/Label.text = "On"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		$TabContainer/General/MarginContainer/GridContainer/HBoxContainer5/Label.text = "Off"


func _on_reset_fullscreen_pressed():
	pass # Replace with function body.
