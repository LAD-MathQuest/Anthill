#------------------------------------------------------------------------------%
extends Node
class_name ChallengeManager

#------------------------------------------------------------------------------%
class Challenge:
	var extras:      Array[String] = []
	var question:    String        = ''
	var answer:      String        = ''
	var distractors: Array[String] = []

#------------------------------------------------------------------------------%
static func num_levels() -> int:
	return len(_levels)

#------------------------------------------------------------------------------%
static func get_challenge(level) -> Challenge:
	return _levels[level][0].call(_levels[level][1])

#------------------------------------------------------------------------------%
static var _levels: Array = [
	[challenge_simple_arithmetic_sum,     0],
	[challenge_simple_arithmetic_sum,     2],
	[challenge_simple_arithmetic_sum,     4],
	[challenge_simple_arithmetic_product, 4],
	[challenge_sum_arithmetic_parcel,     4],
	[challenge_equation_solution,         4],
]

#------------------------------------------------------------------------------%
static func random_numbers(
	n: int,
	min_val: int,
	max_val: int,
	exclude: Array = [0]
) -> Array:

	var values = range(min_val, max_val + 1)

	values = values.filter(func(x): return not exclude.has(x))
	values.shuffle()

	return values.slice(0, n)

#------------------------------------------------------------------------------%
static func challenge_simple_arithmetic_sum(n: int) -> Challenge:

	var a = randi_range(1, 9)
	var b = randi_range(1, 9)
	var v = a + b

	var challenge = Challenge.new()
	challenge.question = "%d + %d = _" % [a, b]
	challenge.answer   = str(v)

	if n > 0:
		var errors = random_numbers(n, -5, 5, [0])
		for e in errors:
			challenge.distractors.append(str(v + e))

	return challenge

#------------------------------------------------------------------------------%
static func challenge_sum_arithmetic_parcel(n: int) -> Challenge:
	var a = randi_range(1, 9)  # 1-9 inclusive
	var b = randi_range(1, 9)
	var v = a + b

	var challenge = Challenge.new()
	challenge.question = "%d + _ = %d" % [a, v]
	challenge.answer = str(b)

	if n > 0:
		var errors = random_numbers(n, -5, 5, [0])
		for e in errors:
			challenge.distractors.append(str(b + e))

	return challenge

#------------------------------------------------------------------------------%
static func challenge_simple_arithmetic_product(n: int) -> Challenge:

	var a = randi_range(1, 9)
	var b = randi_range(1, 9)
	var v = a * b

	var challenge = Challenge.new()
	challenge.question = "%d × %d = _" % [a, b]
	challenge.answer   = str(v)

	if n > 0:
		var errors = random_numbers(n, -5, 5, [0])
		for e in errors:
			challenge.distractors.append(str(v + e))

	return challenge

#------------------------------------------------------------------------------%
static func challenge_equation_solution(n: int) -> Challenge:
	var a = randi_range(1, 9)
	var b = randi_range(1, 9)
	var x = randi_range(1, 9)
	var c = a * x + b

	var challenge = Challenge.new()
	challenge.extras.append("%dx + %d = %d" % [a, b, c])
	challenge.question = "x = _"
	challenge.answer   = str(x)

	if n > 0:
		var errors = random_numbers(n, -5, 5, [0])
		for e in errors:
			challenge.distractors.append(str(x + e))

	return challenge

#------------------------------------------------------------------------------%
