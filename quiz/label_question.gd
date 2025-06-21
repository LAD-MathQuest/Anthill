#------------------------------------------------------------------------------%
extends PanelContainer
class_name LabelQuestion

var text: String:
	set(_text):
		%Label.text = _text
	get:
		return %Label.text

@onready var label: Label = %Label

const shaker : Resource = preload("res://quiz/vfx/shake_and_flash.gdshader")
var shader_material: Material = ShaderMaterial.new()

#------------------------------------------------------------------------------#
func _ready() -> void:
	var shader = Shader.new()
	shader_material.shader = shaker
	shader_material.set("shader_parameter/hit_effect",     0.2)
	shader_material.set("shader_parameter/shake_intensity", 15)

#------------------------------------------------------------------------------#
func show_success() -> void:
	modulate = Color(0,1,0)
	create_tween().tween_property(self, "modulate", Color(1,1,1), 0.3) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_IN)

#------------------------------------------------------------------------------#
func show_failure() -> void:
	modulate       = Color(1,0,0)
	label.material = shader_material
	await get_tree().create_timer(0.2).timeout
	label.material = null
	modulate       = Color(1,1,1)

#------------------------------------------------------------------------------#
const this_scene: PackedScene = preload("res://quiz/label_question.tscn")
static func produce(_text: String) -> LabelQuestion:
		var scene = this_scene.instantiate()
		scene.text = _text
		return scene

#------------------------------------------------------------------------------%
