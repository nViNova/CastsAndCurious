extends Node2D

signal correct_answer
signal wrong_answer

export var cats = [
	#[NAME, QUESTOIN, IMAGE PATH]
	["Welding Cutters", "These felines are responsible for the junction and assembly of car parts in its assembly.", "res://Assets/Level5/resized/resizedGiorno.png"],
	["Molding Operators", "These fellas operate on the coremaking of machines as well as metalcasting or molding of car parts.", "res://Assets/Level5/resized/resizedChild Labor.png"],
	["Construction Laborers", "These fixers are given labor work in the construction of automotive parts.", "res://Assets/Level5/resized/resizedGigacat.png"],
]

var current_question = 0
onready var description = get_node("%Image/Label")
onready var buttons = get_node("CanvasLayer/Control/Buttons")

func _ready():
	get_node("/root/StateMachine").pause_level_timer()
	connect("correct_answer", self, "answer_correct")
	connect("wrong_answer", self, "answer_wrong")
	for button in buttons.get_children():
		button.connect("pressed", self, "on_pressed", [button])
	randomize()
	cats.shuffle()
	show_question()
	$AnimationPlayer.play("show_question")

func show_question():
	var question = cats[current_question][1]
	description.bbcode_text = "[center]" + question
	
	var choices = one_nonrandom_element(current_question, buttons.get_children().size(), cats)
	for btn_index in range(buttons.get_children().size()):
		var button = buttons.get_children()[btn_index]
		button.get_child(0).texture = load(choices[btn_index][2])

func random_n_elements(n, elements):
	var output = []
	var new_elements = elements.duplicate()
	new_elements.shuffle()
	for i in range(n):
		output.append(new_elements[i])
	return output

func one_nonrandom_element(i, n, elements):
	var new_elements = elements.duplicate()
	var output = []
	output.append(new_elements.pop_at(i))
	output.append_array(random_n_elements(n-1, new_elements))
	output.shuffle()
	return output

func on_pressed(button):
	if current_question >= len(cats):
		return
	var answer = button.get_child(0).texture
	if answer == load(cats[current_question][2]):
		emit_signal("correct_answer")
	else:
		emit_signal("wrong_answer")
	pass

func answer_correct():
	current_question += 1
	$AnimationPlayer.play("correct")
	get_node("/root/StateMachine").level_done()
	#if current_question >= len(cats):
	#	var sm = get_node_or_null("/root/StateMachine")
	#	if sm != null:
	#		sm.level_done()
	#	return
	#show_question()
func answer_wrong():
	$AnimationPlayer.play("wrong")
	get_node("/root/StateMachine").penalize()

func continue_timer():
	get_node("/root/StateMachine").continue_level_timer()