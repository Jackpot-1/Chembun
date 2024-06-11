extends Control

var recipe = ""
var cookbookOld = {
	"H[b]2[/b]+O":"Water",
	"Na+Cl":"Salt",
	"N+H[b]3[/b]":"Ammonia",
	"Fe[b]2[/b]+O[b]3[/b]":"Rust",
	"C+O":"Carbon Monoxide",
	"H[b]2[/b]+O[b]2[/b]": "Hydrogen Peroxide",
	"C+H[b]4[/b]" : "Methane",
	"C[b]6[/b]+H[b]12[/b]+O[b]6[/b]" : "Glucose", # can't make this cause number can't go above 9
	"C[b]2[/b]+H[b]5[/b]+O+H" : "Ethanol",
	"C[b]3[/b]H[b]8[/b]" : "Propane",
	"H+Cl" : "Hydrochloric Acid",
	"Na[b]2[/b]+O" : "Sodium Oxide",
	"Na[b]2[/b]+O[b]2[/b]" : "Sodium Peroxide",
	"Fe[b]3[/b]+O[b]4[/b]" : "Magnetite",
	"HgC[b]2[/b]N[b]2[/b]O[b]2[/b]" : "Mercury(II) Fulmainate",
	"C[b]7[/b]H[b]5[/b]N[b]3[/b]O[b]6[/b]" : "TNT"
	#fire = carbon dioxide, water vapor, oxygen, nitrogen
}

var cookbook = {
	"H[b]2[/b]+O":"Water",
	"Hg+C[b]2[/b]+N[b]2[/b]+O[b]2[/b]" : "Mercury(II) Fulminate"
}

func spin():
	$Vircle.rotation_speed = 0.2
	await get_tree().create_timer(2).timeout
	$Vircle.rotation_speed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	transfer(6)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func element_adder(element):
	var ingredient = recipe.split("+")
	ingredient = ingredient[-1]
	if(len(recipe) == 0):
		recipe = element
	elif(ingredient == element):
		recipe = recipe + "[b]2[/b]" #[b] is bold
	elif(ingredient.left(-8) != element):
		print(ingredient, " ingredient")
		print(recipe, " recipe")
		print(len(recipe))
		recipe = recipe + "+" + element
		print(recipe)
	if len(ingredient) >= 8:
		if(ingredient[-5].is_valid_int() and ingredient.left(-8) == element):
			if(ingredient[-5] == "9"):
				recipe = recipe.left(-8) # sets recipe back to element without the number
			else:
				var num = (recipe[-5]).to_int() + 1
				recipe = recipe.left(-8) + "[b]" + str(num) + "[/b]"
	
	
	print(recipe)
	$VBoxContainer/RichTextLabel.text = "[center]" + recipe
	#$VBoxContainer/RichTextLabel.text = "[font_size=70][center]" + recipe.replace_all("\\d", "[font_size=40][b][color=gray]\\0[/color][/b][font_size=70]")
	if cookbook.has(recipe):
		print(cookbook[recipe])
		$"../hotbar".slotInserter(load("res://assets/images/items/"+ cookbook[recipe] + ".tres"))
		$VBoxContainer/RichTextLabel.text = "[center]" + cookbook[recipe]
#[font_size=70][center]He[font_size=40][b][color=gray]2[/color][/b][font_size=70]C[font_size=40][b][color=gray]3[/color][/b]

# this function transfers the buttions from $ElementStorage to $Vircle, because you will gradually gain them over time
func transfer(howManyElementsToAdd: int):
	if $ElementStorage.get_children().size() == 0: return
	for i in howManyElementsToAdd:
		if $ElementStorage.get_children().size() == 0: return
		$ElementStorage.get_children()[0].reparent($Vircle, false)
	
	match $Vircle.get_children().size():
		1:
			$Vircle.radius = 0
			$Vircle.rotation_degrees = 0
		2:
			$Vircle.radius = 150
			$Vircle.rotation_degrees = 0
		3:
			$Vircle.radius = 185
			$Vircle.rotation_degrees = 30
		4:
			$Vircle.radius = 210
			$Vircle.rotation_degrees = 45
		5:
			$Vircle.radius = 220
			$Vircle.rotation_degrees = -90
		6:
			$Vircle.radius = 220
			$Vircle.rotation_degrees = 0
		7:
			$Vircle.radius = 220
			$Vircle.rotation_degrees = 90
		8:
			$Vircle.radius = 227
			$Vircle.rotation_degrees = 0
		
			
			
		#if $Vircle.get_children().size() == 1:
			#$Vircle.radius = 0
		#if $Vircle.get_children().size() == 5:
			#$Vircle.rotation = -90
		#else: $Vircle.rotation = 0
		#$Vircle.radius += 35

func _on_texture_button_1_pressed():
	element_adder("H")


func _on_texture_button_2_pressed():
	element_adder("O")


func _on_texture_button_3_pressed():
	element_adder("C")


func _on_texture_button_4_pressed():
	element_adder("Hg")


func _on_texture_button_5_pressed():
	element_adder("N")


func _on_texture_button_6_pressed():
	element_adder("Fe")


func _on_texture_button_7_pressed():
	element_adder("Cl")


func _on_texture_button_8_pressed():
	element_adder("Na")
