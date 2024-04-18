extends Control

func _ready():
	$MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/ReturnButton.grab_focus()

func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://assets/Scenes/Screens/MainMenuScreen.tscn")
