#------------------------------------------------------------------------------#
class_name MainMenu extends Control

@export var names:  Array[String]
@export var scenes: Array[PackedScene]
@export var background_color: Color = Color(0.32, 0.32, 0.32)

@onready var background:       ColorRect     = %Background
@onready var project_name:     Label         = %ProjectName
@onready var projetct_icon:    TextureRect   = %ProjetctIcon
@onready var button_container: VBoxContainer = %ButtonContainer

var button_group: ButtonGroup
var scenes_by_button: Dictionary

static var scene_tree

#------------------------------------------------------------------------------#
func _ready() -> void:

	assert(
		names.size() == scenes.size(),
		'Names and Scenes must have the same number of elements!'
	)

	scene_tree = get_tree()

	background.size = get_viewport_rect().size
	background.color = background_color

	project_name.text = ProjectSettings.get_setting("application/config/name")

	var icon_path = ProjectSettings.get_setting("application/config/icon")
	projetct_icon.texture = load(icon_path) if icon_path else null

	button_group = ButtonGroup.new()
	button_group.pressed.connect(_on_button_group_pressed)

	for ii in range(names.size()):
		var button = Button.new()
		button.text = names [ii]
		button.toggle_mode = true
		button.button_group = button_group
		button.custom_minimum_size = Vector2(180, 60)
		button_container.add_child(button)

		scenes_by_button[button] = scenes[ii]

#------------------------------------------------------------------------------#
func _on_button_group_pressed(button: BaseButton) -> void:
	get_tree().change_scene_to_packed(scenes_by_button[button])

#------------------------------------------------------------------------------#
func _on_button_quit_pressed() -> void:
		get_tree().quit()

#------------------------------------------------------------------------------#
const this_scene: PackedScene = preload("res://main_menu/main_menu.tscn")
static func load() -> void:
	scene_tree.change_scene_to_packed(this_scene)

#------------------------------------------------------------------------------#
