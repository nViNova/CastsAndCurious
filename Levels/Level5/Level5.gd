extends Node2D

signal correct_answer
signal wrong_answer

export var cats = [
	#[NAME, QUESTOIN, IMAGE PATH]
	["CAT1", "THIS IS CAT1", ".png"],
	["CAT2", "THIS IS CAT2", ".png"],
	["CAT3", "THIS IS CAT3", ".png"],
]

var current_question = 0

onready var image = get_node("%Image/TextureRect")
onready var description = get_node("%Image/Label")
onready var buttons = get_node("CanvasLayer/Control/Buttons")

func _ready():
	connect("correct_answer", self, "answer_correct")
	connect("wrong_answer", self, "answer_wrong")
	for button in buttons.get_children():
		button.connect("pressed", self, "on_pressed", [button])
	randomize()
	cats.shuffle()
	show_question()

func show_question():
	var question = cats[current_question][1]
	var image_path = cats[current_question][2]
	if image_path == ".png": image_path = "icon.png"
	image.texture = load(image_path)
	description.text = question
	
	var choices = one_nonrandom_element(current_question, buttons.get_children().size(), cats)
	for btn_index in range(buttons.get_children().size()):
		var button = buttons.get_children()[btn_index]
		button.get_child(0).text = choices[btn_index][0]

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
	var answer = button.get_child(0).text
	if answer == cats[current_question][0]:
		emit_signal("correct_answer")
	else:
		emit_signal("wrong_answer")
	pass

func answer_correct():
	current_question += 1
	if current_question >= len(cats):
		var sm = get_node_or_null("/root/StateMachine")
		if sm != null:
			sm.level_done()
		return
	show_question()

func answer_wrong():
	#print('OH NO')
	pass