#------------------------------------------------------------------------------#
class_name Leaf extends Area2D

@onready var sprite_leaf_1:   Sprite2D = %SpriteLeaf1
@onready var sprite_leaf_2:   Sprite2D = %SpriteLeaf2
@onready var sprite_leaf_3:   Sprite2D = %SpriteLeaf3
@onready var sprite_leaf_4:   Sprite2D = %SpriteLeaf4
@onready var sprite_leaf_5:   Sprite2D = %SpriteLeaf5
@onready var sprite_leaf_6:   Sprite2D = %SpriteLeaf6
@onready var collision_shape: CollisionShape2D = %CollisionShape2D
@onready var label:           Label = %Label

var text: String:
	set(text):
		label.text = text
	get:
		return label.text

var is_carried: bool        = false
var carrier: Node2D         = null
var can_be_picked_up: bool  = false
var player_in_range: Node2D = null
var previous_parent: Node2D = null

const color_modulate: Color = Color(0.348, 0.81, 0.502)

var style: int = 1

#------------------------------------------------------------------------------#
func _ready() -> void:
	match style:
		1: sprite_leaf_1.visible = true
		2: sprite_leaf_2.visible = true
		3: sprite_leaf_3.visible = true
		4: sprite_leaf_4.visible = true
		5: sprite_leaf_5.visible = true
		6: sprite_leaf_6.visible = true

	modulate = color_modulate
	position = Vector2(
		randf_range(100, 800),
		randf_range(100, 500)
	)

	print('end ready')

#------------------------------------------------------------------------------#
func _on_body_entered(body):
	if not is_carried and body.is_in_group("player"):
		body.leaf_entered_range(self)
		player_in_range  = body
		can_be_picked_up = true
		modulate = Color.WHITE

#------------------------------------------------------------------------------#
func _on_body_exited(body):
	if body == player_in_range:
		body.leaf_exited_range(self)
		player_in_range  = null
		can_be_picked_up = false
		modulate = color_modulate

#------------------------------------------------------------------------------#
func pick_up(by):
	if not can_be_picked_up or is_carried: return false

	is_carried       = true
	carrier          = by
	can_be_picked_up = false
	player_in_range  = null

	modulate = color_modulate
	previous_parent = get_parent()
	previous_parent.remove_child(self)
	carrier.add_child(self)
	position = Vector2(0, -60)
	rotation_degrees = -110
	collision_shape.disabled = true

	return true

#------------------------------------------------------------------------------#
func drop():
	if not is_carried: return

	is_carried = false
	carrier.remove_child(self)
	previous_parent.add_child(self)
	position = carrier.position + Vector2(0, -60)
	rotation = 0
	carrier  = null
	collision_shape.disabled = false

#------------------------------------------------------------------------------#
const this_scene: PackedScene = preload("res://topdown/leaf.tscn")
static func produce() -> Leaf:
		var scene = this_scene.instantiate()
		scene.style = randi_range(1,6)
		return scene

#------------------------------------------------------------------------------#
