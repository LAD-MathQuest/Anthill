#------------------------------------------------------------------------------%
extends Control

var success:  int = 0
var failure:  int = 0
var level:    int = 0
var n_levels: int = 0

var correct_answer: String = ''
var option_buttons = ButtonGroup.new()

@onready var extras_container:   HBoxContainer  = %ExtrasContainer
@onready var options_container:  HBoxContainer  = %OptionsContainer
@onready var end_game_display:   PanelContainer = %EndGameDisplay
@onready var quiz_container:     VBoxContainer  = %QuizContainer
@onready var success_display:    PanelContainer = %SuccessDisplay
@onready var failure_display:    PanelContainer = %FailureDisplay
@onready var label_success:      Label          = %LabelSuccess
@onready var label_failure:      Label          = %LabelFailure
@onready var label_progress:     Label          = %LabelProgress
@onready var curtain:            ColorRect      = %Curtain
@onready var label_question:     LabelQuestion  = %LabelQuestion
@onready var fireworks:          Node           = %Fireworks

#------------------------------------------------------------------------------%
func _ready() -> void:
	n_levels = ChallengeManager.num_levels()

	option_buttons.pressed.connect(_option_button_pressed)
	build_challenge.call_deferred()

#------------------------------------------------------------------------------%
func build_challenge() -> void:

	update_score.call_deferred()

	# Remove previous challenge
	var children =        extras_container.  get_children()
	children.append_array(options_container. get_children())

	for child in children:
		child.free()

	# Check if end game
	if level == n_levels:
		end_game_display.visible = true
		quiz_container.visible   = false
		return

	quiz_container.visible = true

	# Get new challenge
	var challenge = ChallengeManager.get_challenge(level)

	# Show the question
	label_question.text = challenge.question

	# Store the correct answer
	correct_answer = challenge.answer
	var options = [correct_answer]

	# Mix the correct answer with the distractos
	for text in challenge.distractors:
		options.append(text)

	# Cheating
	#print('Correct answer = ', correct_answer)
	#options.shuffle()

	for option in options:
		var button = ButtonOption.produce(option)
		button.button_group = option_buttons
		options_container.add_child(button)

	for text in challenge.extras:
		var extra = LabelExtra.produce(text)
		extras_container.add_child(extra)

#------------------------------------------------------------------------------%
func _option_button_pressed(button: BaseButton) -> void:

	if button.text == correct_answer:
		success += 1
		level   += 1
		label_question.show_success.call_deferred()
		show_success.call_deferred()
	else:
		failure += 1
		label_question.show_failure.call_deferred()
		show_failure.call_deferred()

	build_challenge.call_deferred()

#------------------------------------------------------------------------------%
func show_success() -> void:
	if level < n_levels:
		success_display.visible = true

	var particles = fireworks.get_children()
	particles.shuffle()

	for p in particles:
		var pos = p.position
		p.position += Vector2(randf_range(-30, 30), randf_range(-20, 20))
		p.restart()
		await get_tree().create_timer(randf_range(0.001, 0.1)).timeout
		p.position = pos

	await get_tree().create_timer(0.5).timeout
	success_display.visible = false

#------------------------------------------------------------------------------%
func show_failure() -> void:
	failure_display.visible = true
	await get_tree().create_timer(0.5).timeout
	failure_display.visible = false

#------------------------------------------------------------------------------%
func update_score() -> void:
	label_success.text  = str(success)
	label_failure.text  = str(failure)
	label_progress.text = '%d/%d' % [level, n_levels]

#------------------------------------------------------------------------------%
func _on_button_restart_pressed() -> void:
	success = 0
	failure = 0
	level   = 0
	end_game_display.visible = false
	build_challenge.call_deferred()

	var tween = create_tween()
	tween.tween_property(curtain, "modulate:a", 1, 0.1).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(curtain, "modulate:a", 0, 0.1).set_trans(Tween.TRANS_CUBIC)

#------------------------------------------------------------------------------%
func _on_button_home_pressed() -> void:
	MainMenu.load()

#------------------------------------------------------------------------------%
func _on_button_quit_pressed() -> void:
		get_tree().quit()

#------------------------------------------------------------------------------%
