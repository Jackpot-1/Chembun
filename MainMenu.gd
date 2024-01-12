extends Control


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Playground.tscn")



func _on_credit_button_pressed():
	get_tree().change_scene_to_file("res://CreditMenu.tscn")
	


func _on_quit_pressed():
	get_tree().quit()
	
