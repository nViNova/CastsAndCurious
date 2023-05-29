extends Node2D


export var processes = [
	#"NAME, DESCRIPTION, IMAGE PATH"
	["ENGINE FITMENT AND ASSEMBLY", "1", ".png"],
	["STAMPING OR PRESSING", "2", ".png"],
	["FINAL INSPECTION AND TESTING", "3", ".png"],
	["WELDING OR BODY SHOP", "4", ".png"],
	["PAINT ASSEMBLY", "5", ".png"],
	["DESIGN AND ENGINEERING", "6", ".png"],
	["MATERIAL REWORKING", "7", ".png"]
]

var current_q = 0

onready var cat = get_node("%Cat")
onready var description = get_node("%Description")
onready var buttons_container = get_node("%Buttons")

func _ready():
	for button in buttons_container.get_children():
		button.connect('pressed', self, '_on_button_pressed', [button])

	randomize()
	processes.shuffle()
	show_question()

func show_question():
	if current_q >= len(processes):
		return

	if processes[current_q][2] == ".png":
		processes[current_q][2] = "res://icon.png"
	
	cat.texture = load(processes[current_q][2])
	description.text = processes[current_q][1]

	var buttons = buttons_container.get_children()
	buttons.shuffle()
	var choices = one_nonrandom_element(current_q, len(buttons), processes)
	for button_index in range(len(buttons)):
		var button = buttons[button_index]
		button.get_child(0).text = choices[button_index][0]
	

func _on_button_pressed(button):
	if current_q >= len(processes):
		return
	var choice = button.get_node("Label").text
	var answer = processes[current_q][0]
	print("your choice " + choice + ", correct answer: " + answer)
	if choice == answer:
		print("correct!")
		current_q += 1
		show_question()
	else:
		print("wrong")

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
