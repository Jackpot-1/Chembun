extends Control

var recipe = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func element_adder(element):
	var index_calc = len(element)
	var ingredient = recipe.split(" + ")
	ingredient = ingredient[-1]
	if(len(recipe) == 0):
		recipe = recipe + element
	elif(ingredient[-1].is_valid_int() and ingredient.left(-1) == element):
		if(ingredient[-1] == "9"):
			recipe = recipe.left(-1)
		else:
			var num = (recipe[-1]).to_int() + 1
			recipe = recipe.left(-1) + str(num)
	elif(ingredient == element):
		recipe = recipe + str(2)
	elif(len(recipe)) > 0:
		recipe = recipe + " + " + element
	print(recipe)


func _on_texture_button_pressed():
	element_adder("H")


func _on_texture_button_2_pressed():
	element_adder("Cl")


func _on_texture_button_3_pressed():
	element_adder("O")


func _on_texture_button_4_pressed():
	element_adder("Na")


func _on_texture_button_5_pressed():
	element_adder("B")


func _on_texture_button_6_pressed():
	element_adder("C")
