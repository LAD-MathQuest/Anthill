#------------------------------------------------------------------------------%
extends Button
class_name ButtonOption

#------------------------------------------------------------------------------#
const this_scene: PackedScene = preload("res://quiz/button_option.tscn")
static func produce(_text: String) -> ButtonOption:
		var scene = this_scene.instantiate()
		scene.text = _text
		return scene

#------------------------------------------------------------------------------%
