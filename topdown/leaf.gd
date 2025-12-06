#------------------------------------------------------------------------------#
class_name Leaf extends Area2D

@export var modulate_normal:    Color = Color.WHITE
@export var modulate_collision: Color = Color(0.497, 0.635, 0.655)

@onready var sprite_leaf_1:   Sprite2D = %SpriteLeaf1
@onready var sprite_leaf_2:   Sprite2D = %SpriteLeaf2
@onready var sprite_leaf_3:   Sprite2D = %SpriteLeaf3
@onready var sprite_leaf_4:   Sprite2D = %SpriteLeaf4
@onready var sprite_leaf_5:   Sprite2D = %SpriteLeaf5
@onready var sprite_leaf_6:   Sprite2D = %SpriteLeaf6
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

	modulate = modulate_normal
	position = Vector2(
		randf_range(100, 800),
		randf_range(100, 500)
	)

#------------------------------------------------------------------------------#
func _on_body_entered(body: Node2D) -> void:
	if not is_carried and body.is_in_group("player"):
		body.leaf_entered_range(self)
		player_in_range  = body
		can_be_picked_up = true
		modulate = modulate_collision

#------------------------------------------------------------------------------#
func _on_body_exited(body: Node2D) -> void:
	if body == player_in_range:
		body.leaf_exited_range(self)
		player_in_range  = null
		can_be_picked_up = false
		modulate = modulate_normal

#------------------------------------------------------------------------------#
func pick_up(by: Node2D) -> bool:
	if not can_be_picked_up or is_carried: return false

	is_carried       = true
	carrier          = by
	can_be_picked_up = false
	player_in_range  = null

	modulate = modulate_normal
	previous_parent = get_parent()
	previous_parent.remove_child(self)
	carrier.add_child(self)
	position = Vector2(0, -60)
	rotation_degrees = -110
	collision_mask = 8

	return true

#------------------------------------------------------------------------------#
func drop() -> void:
	if not is_carried: return

	is_carried = false
	carrier.remove_child(self)
	previous_parent.add_child(self)
	position = carrier.position + Vector2(0, -60)
	rotation = 0
	carrier  = null
	collision_mask = 10

#------------------------------------------------------------------------------#
const this_scene: PackedScene = preload("res://topdown/leaf.tscn")
static func produce() -> Leaf:
		var scene = this_scene.instantiate()
		scene.style = randi_range(1,6)
		return scene

#------------------------------------------------------------------------------#
