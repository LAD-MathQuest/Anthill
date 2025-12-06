#------------------------------------------------------------------------------#
class_name Anthill extends Area2D

signal solution_found

@onready var label:      Label     = %Label
@onready var color_rect: ColorRect = %ColorRect

var question: String:
	set(text):
		label.text = text
	get:
		return label.text

var answer: String = ""

#------------------------------------------------------------------------------#
func _on_area_entered(leaf: Area2D) -> void:
	if leaf.text == answer:
		solution_found.emit()
	else:
		color_rect.visible = true
		await get_tree().create_timer(0.5).timeout
		color_rect.visible = false


#------------------------------------------------------------------------------#
