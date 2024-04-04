extends Node3D

@onready var enemy = Globals.Enemy.new("SaltBlock")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# https://www.theguardian.com/society/2024/apr/02/new-science-of-death-brain-activity-consciousness-near-death-experience?utm_source=pocket-newtab-en-us

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(enemy.damage)
