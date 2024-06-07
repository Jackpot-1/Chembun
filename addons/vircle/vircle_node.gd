@tool
extends Control

##What distance should the children elements have to the center of the Vircle
@export var radius:float = 100.0:
	set(new):
		radius = new
		if is_node_ready():
			place_elements(get_items(), new)

##Adjust the size of all children. This value can be updated via code and be used for popup animations and such.
@export var element_size:float = 40.0:
	set(new):
		element_size = new
		place_elements(get_items(), radius, new)

@export_group("Rotation")

##How quick should children elements rotate
@export var rotation_speed:float = 0.0:
	set(new):
		rotation_speed = new
		set_process(new != 0.0)
		if new == 0.0:
			rotation = 0.0
			reset_child_rotations()
			set_process(false)

##If true, all Children will always be upright reguardless of the rotation of the parent. This will also ignore all parents rotation above the Vircle
@export var keep_upright:bool = true:
	set(new):
		keep_upright = new
		if new:
			for child in get_children():
				if child is Control:
					child.pivot_offset = child.size / 2.0
		else:
			reset_child_rotations()

##Preview the rotation of the children with this option
@export var editor_preview:bool = true:
	set(new):
		editor_preview = new
		if rotation_speed != 0.0:
			set_process(true)
		if new == false:
			set_process(false)
			rotation = 0.0
			reset_child_rotations()

func reset_child_rotations():
	for item in get_items():
		item.rotation = 0.0

func get_items():
	var items:Array[CanvasItem]
	for node in get_children():
		if node is CanvasItem:
			items.append(node)
	return items

func _ready():
	pivot_offset = size * 0.5
	child_order_changed.connect(place_elements)
	resized.connect(place_elements)
	place_elements()

func _process(delta):
	if !editor_preview and Engine.is_editor_hint():
		set_process(false)
		rotation = 0.0
		for i in get_children():
			i.rotation = 0.0
	rotation += rotation_speed * delta
	if keep_upright:
		for child in get_children():
			if child is CanvasItem or child is Control or child is Node2D:
				child.rotation = -rotation

func place_elements(items:Array[CanvasItem] = get_items(), _radius:float = radius, _element_size:float = element_size):
	pivot_offset = size * 0.5
	var step:float = (PI * 2.0) / items.size()
	var angle:float = 0.0
	for node in items:
		if node is Control:
			node.size = Vector2(_element_size, _element_size)
			node.pivot_offset = node.size / 2.0
			node.position = (Vector2.RIGHT * _radius).rotated(angle) - node.size * 0.5 + pivot_offset
		else:
			node.position = (Vector2.RIGHT * _radius).rotated(angle) + pivot_offset
		angle += step
