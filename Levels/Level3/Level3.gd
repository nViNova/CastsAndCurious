extends Node2D

signal correct_answer
signal wrong_answer

export var parts = [
	["Gear Shifter", "Changes gear ratio", "res://Assets/Level3/resized/resizedGears.png"],
	["Cooling Expansion Tank", "Stores excess liquid engine coolant", "res://Assets/Level3/resized/resizedFluid Tank.png"],
	["Alternator", "Distributes steady streams of power", "res://Assets/Level3/resized/resizedElectric Fan.png"],
	["Radiator", "For heat exchange in an engine.", "res://Assets/Level3/resized/resizedRadiator.png"],
	["Exhaust Manifold", "Collect exhaust from engine cylinders.", "res://Assets/Level3/resized/exhaust_manifold.png"],
	["Power Steering Fluid", "Stores fuel for steering system", "res://Assets/Level3/resized/power_steering_fluid.png"],
	["Steering Wheel","Dictates vehicle direction","res://Assets/Level3/resized/steering_wheel.png"],
	["Torque Converter","A doughnut-shaped fluid coupling","res://Assets/Level3/resized/torque_converter.png"],
]

var current_question = 0
var correct_answer = ""

onready var image_node = get_node("%Image")
onready var button_node = get_node("%Buttons")

func _ready():
	randomize()
	parts.shuffle()
	
	connect("correct_answer", self, "answer_correct")
	connect("wrong_answer", self, "answer_wrong")
	for button in button_node.get_children():
		button.connect('pressed', self, 'answer_picked', [button])
	
	show_question()
	
func show_question():
	if current_question >= len(parts):
		var sm = get_node_or_null("/root/StateMachine")
		if sm != null:
			sm.level_done()
		return

	$AnimationPlayer.play("show_question")

	if parts[current_question][2] == ".png":
		parts[current_question][2] = "res://icon.png"

	var image = load(parts[current_question][2])

	var buttons = button_node.get_children()
	buttons.shuffle()

	var first_number = current_question
	var second_number = current_question
	var third_number = current_question

	while first_number == second_number:
		second_number = randi() % len(parts)
	while first_number == third_number or second_number == third_number:
		third_number = randi() % len(parts)

	var question = randi() % 2
	var answer = -1
	if question == 0:
		answer = 1
	else:
		answer = 0

	correct_answer = parts[first_number][answer]
	buttons[0].text = parts[first_number][answer] 
	buttons[1].text = parts[second_number][answer]
	buttons[2].text = parts[third_number][answer] 

	get_node("%Label").text = parts[first_number][question]

	get_node("%Image").texture = image


func answer_picked(button):
	var answer = button.text
	if answer == correct_answer:
		emit_signal("correct_answer")
	else:
		emit_signal("wrong_answer")

func answer_correct():
	get_node("/root/StateMachine").level_done()
	#current_question += 1
	#show_question()

func answer_wrong():
	get_node("/root/StateMachine").penalize()
	pass
