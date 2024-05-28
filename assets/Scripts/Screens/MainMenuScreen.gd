extends Control

func _ready():
	#$AnimationPlayer.play("RESET")
	$AnimationPlayer.play("title_in")
	
func _on_animation_player_animation_finished(anim_name):
	match anim_name: # have you heard of out lord and savior "match"?
		"title_in":
			$AnimationPlayer.play("bun_in")
		"bun_in":
			$AnimationPlayer.play("buttons_in")
		"buttons_in":
			$MainMenu/Quit.grab_focus()
			$MainMenu/Credits.grab_focus()
			$MainMenu/NewGame.grab_focus()
			$MainMenu/Continue.grab_focus()
		"all_out":
			$MainMenu/Title.visible = false
			$MainMenu/Bun.visible = false
			$MainMenu/Continue.visible = false
			$MainMenu/NewGame.visible = false
			$MainMenu/Credits.visible = false
			$MainMenu/Quit.visible = false

func _on_continue_pressed():
	$MenuClick.play()
	if Globals.CinematicFinished:
		get_tree().change_scene_to_file(Globals.current_scene)
	else:
		Globals.CinematicFinished = true
		get_tree().change_scene_to_file("res://assets/Miscellaneous/Cinematic.tscn")

func _on_new_game_pressed():
	$MenuClick.play()
	#get_tree().change_scene_to_file("res://assets/Scenes/Screens/SettingsScreen.tscn")
	Globals.reset_data()
	# ask, "are you sure?"
	Globals.CinematicFinished = true
	get_tree().change_scene_to_file("res://assets/Miscellaneous/Cinematic.tscn")

func _on_credits_pressed():
	pass # Replace with function body.
	#get_tree().change_scene_to_file("res://assets/Scenes/Screens/CreditsScreen.tscn")
	$CreditsScreen.visible = true
	$CreditsScreen/AnimationPlayerCredits.play("credits_in")
	$AnimationPlayer.play("all_out")

#func _on_credits_button_pressed():
	#$MenuClick.play()
	#get_tree().change_scene_to_file("res://assets/Scenes/Screens/CreditsScreen.tscn")

func _on_quit_pressed():
	$MenuClick.play()
	get_tree().quit()


func _on_start_button_mouse_entered():
	$MenuHover.play()


func _on_settings_button_mouse_entered():
	$MenuHover.play()


func _on_credits_button_mouse_entered():
	$MenuHover.play()


func _on_quit_button_mouse_entered():
	$MenuHover.play()

