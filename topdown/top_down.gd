#------------------------------------------------------------------------------#
class_name TopDown extends Node2D

var success:  int = 0
var level:    int = 0
var n_levels: int = 0

var correct_answer: String = ''

@onready var anthill: Area2D = %Anthill
@onready var leaves:  Node2D = %Leaves
@onready var ant: Ant = %Ant

#------------------------------------------------------------------------------%
func _ready() -> void:
	n_levels = ChallengeManager.num_levels()
	build_challenge.call_deferred()

#------------------------------------------------------------------------------#
func build_challenge() -> void:

	ant.free_leaf()

	# Remove previous leaves
	for child in leaves.get_children():
		child.free()

	# Check if end game
	if level == n_levels:
		print("End game!")
		return

	# Get new challenge
	var challenge = ChallengeManager.get_challenge(level)

	# Show the question
	anthill.question = challenge.question
	anthill.answer   = challenge.answer

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
		var leaf = Leaf.produce()
		set_leaf.call_deferred(leaf, option)

	#for text in challenge.extras:
		#var extra = .produce(text)

#------------------------------------------------------------------------------#
func set_leaf(leaf: Node2D, text: String) -> void:
	leaves.add_child(leaf)
	leaf.text = text

#------------------------------------------------------------------------------#
func _on_anthill_solution_found() -> void:
	success += 1
	level   += 1
	print("Nível: ", level)
	build_challenge()

#------------------------------------------------------------------------------#
