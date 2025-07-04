#------------------------------------------------------------------------------#
class_name TopDown extends Node2D

@onready var anthill: Area2D = %Anthill
@onready var leaves:  Node2D = %Leaves

#------------------------------------------------------------------------------#
func _ready() -> void:

	anthill.text = 'desafio'

	for ii in range(4):
		var leaf = Leaf.produce()
		leaves.add_child(leaf)
		leaf.text = str(ii)

#------------------------------------------------------------------------------#
