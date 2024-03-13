extends Control


#func _on_play_button_pressed():
#	get_tree().change_scene_to_file("res://assets/Scenes/Playground.tscn")
#
#
#
#func _on_credit_button_pressed():
#	get_tree().change_scene_to_file("res://assets/Scenes/Screens/CreditsScreen.tscn")
#
#
#
#func _on_quit_pressed():
#	get_tree().quit()
#

func _input(event):
	if event is InputEventKey:
			get_tree().change_scene_to_file("res://assets/Scenes/Screens/MainMenuScreen.tscn")
