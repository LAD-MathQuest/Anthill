#------------------------------------------------------------------------------#
class_name Ant extends CharacterBody2D

@export var speed = 120

var carried_leaf: Leaf = null
var leaves_in_range: Array[Leaf] = []

#------------------------------------------------------------------------------#
func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_Q):
		get_tree().change_scene_to_file("res://main/main.tscn")

	if event.is_action_pressed("pick_up"):
		if carried_leaf:
			carried_leaf.drop()
			carried_leaf = null
		elif leaves_in_range.size() > 0:
			var leaf = leaves_in_range[0]
			if leaf.pick_up(self):
				carried_leaf = leaf
				leaves_in_range.erase(leaf)

	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

	if Input.is_key_pressed(KEY_SHIFT):
		velocity *= 2.5

	look_at(position + velocity)

	$AnimatedSprite2D.play("walk" if velocity else "idle")

#------------------------------------------------------------------------------#
func leaf_entered_range(leaf: Node2D) -> void:
	if not leaf in leaves_in_range:
		leaves_in_range.append(leaf)

#------------------------------------------------------------------------------#
func leaf_exited_range(leaf: Node2D) -> void:
	if leaf in leaves_in_range:
		leaves_in_range.erase(leaf)

#------------------------------------------------------------------------------#
func free_leaf() -> void:
	if carried_leaf:
		carried_leaf.free()
		carried_leaf = null

#------------------------------------------------------------------------------#
@warning_ignore("unused_parameter")
func _physics_process(delta):
	move_and_slide()

#------------------------------------------------------------------------------#
