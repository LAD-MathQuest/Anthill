#------------------------------------------------------------------------------%
extends PanelContainer
class_name LabelExtra

var text: String:
	set(_text):
		%Label.text = _text
	get:
		return %Label.text

#------------------------------------------------------------------------------#
const this_scene: PackedScene = preload("res://quiz/label_extra.tscn")
static func produce(_text: String) -> LabelExtra:
		var scene = this_scene.instantiate()
		scene.text = _text
		return scene

#------------------------------------------------------------------------------%
