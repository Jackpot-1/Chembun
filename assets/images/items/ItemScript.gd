extends Resource

class_name InvItem

@export var name: String = ""
@export var color: Color
@export var texture: Texture2D
@export var big_texture: Texture2D

#var items = [
	#{
		#"name" : "carrot",
		#"icon" : "res://assets/images/items/ccarrot.png",
		#"composition" : "",
		#"attributes" : "food"
	#},
	#{
		#"name" : "water",
		#"icon" : "",
		#"composition" : "H2O",
		#"attributes" : "water"
	#}
#]
