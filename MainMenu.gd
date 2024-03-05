extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Playground.tscn")

func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://SettingsMenu.tscn")

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://CreditMenu.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
