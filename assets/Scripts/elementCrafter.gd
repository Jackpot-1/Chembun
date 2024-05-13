extends Control

var recipe = ""
var cookbook = {
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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
		$VBoxContainer/RichTextLabel.text = "[center]" + cookbook[recipe]
#[font_size=70][center]He[font_size=40][b][color=gray]2[/color][/b][font_size=70]C[font_size=40][b][color=gray]3[/color][/b]

func _on_texture_button_pressed():
	element_adder("H")


func _on_texture_button_2_pressed():
	element_adder("Cl")


func _on_texture_button_3_pressed():
	element_adder("O")


func _on_texture_button_4_pressed():
	element_adder("Na")


func _on_texture_button_5_pressed():
	element_adder("N")


func _on_texture_button_6_pressed():
	element_adder("Fe")
