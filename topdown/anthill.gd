#------------------------------------------------------------------------------#
class_name Anthill extends Area2D

@onready var label: Label = %Label

var text: String:
	set(text):
		label.text = text
	get:
		return label.text

#------------------------------------------------------------------------------#
