extends Control

func _ready():
	$TextureRect/TextureRect/QuitButton.grab_focus()
	$TextureRect/TextureRect/CreditsButton.grab_focus()
	$TextureRect/TextureRect/SettingsButton.grab_focus()
	$TextureRect/TextureRect/StartButton.grab_focus()

func _on_start_button_pressed():
	if Globals.CinematicFinished:
		get_tree().change_scene_to_file("res://assets/Scenes/Playground.tscn")
	else:
		Globals.CinematicFinished = true
		get_tree().change_scene_to_file("res://assets/Miscellaneous/Cinematic.tscn")

func _on_settings_button_pressed():
	#get_tree().change_scene_to_file("res://assets/Scenes/Screens/SettingsScreen.tscn")
	Globals.reset_data()

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://assets/Scenes/Screens/CreditsScreen.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
