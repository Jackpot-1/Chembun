@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Vircle", "Control", preload("res://addons/vircle/vircle_node.gd"), preload("res://addons/vircle/icon.svg"))
	# Initialization of the plugin goes here.
	pass


func _exit_tree():
	remove_custom_type("Vircle")
	# Clean-up of the plugin goes here.
	pass
