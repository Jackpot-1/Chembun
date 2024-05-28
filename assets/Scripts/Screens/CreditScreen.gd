extends Control

var canScroll = false

func _ready():
	#$MarginContainer/VBoxContainer/VBoxContainer/MarginContainer/ReturnButton.grab_focus()
	pass

func _on_return_button_pressed():
	#get_tree().change_scene_to_file("res://assets/Scenes/Screens/MainMenuScreen.tscn")
	$AnimationPlayerCredits.play("credits_out")
	$"../AnimationPlayer".play("all_in")
	$"../MainMenu/Title".visible = true
	$"../MainMenu/Bun".visible = true
	$"../MainMenu/Continue".visible = true
	$"../MainMenu/NewGame".visible = true
	$"../MainMenu/Credits".visible = true
	$"../MainMenu/Quit".visible = true
	canScroll = false
	
func _process(delta):
	if !canScroll: return
	$MarginContainer/VBoxContainer/ScrollContainer.scroll_vertical += 1
	await get_tree().create_timer(1).timeout


func _on_animation_player_credits_animation_finished(anim_name):
	match anim_name:
		"credits_in":
			canScroll = true
			print("hi")
		"credits_out":
			$MarginContainer/VBoxContainer/ScrollContainer.scroll_vertical = 0
			self.visible = false
