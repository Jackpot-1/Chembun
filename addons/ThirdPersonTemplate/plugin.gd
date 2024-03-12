@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("ThirdPersonController", "CharacterBody3D", preload("res://assets/BunController.gd"), preload("icon.svg"))

func _exit_tree():
	remove_custom_type("ThirdPersonController")
