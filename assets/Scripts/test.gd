extends Node3D

@onready var enemy = Globals.Enemy.new("SaltBlock")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(enemy.damage)
