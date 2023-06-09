extends Node2D


export var processes = [
	#"NAME, DESCRIPTION, IMAGE PATH"
	["Engine Fitment and Assembly", "Mr. Whiskers! My rover still lacks its engine! How will I be able to reach my desired destination?"],
	["Stamping or Pressing", "My car’s doors won’t fit because they’re flat as a flatbread. How would I drive with no doors?"],
	["Final Inspection and Testing", "The car that I bought for my road trip had just finished its assembly, what do we do next."],
	["Welding or Body Shop", "Mr. Whiskers! How would you attach compartments and hoods on a car?"],
	["Paint Assembly", "Mr. Whiskers! I want to make my truck Nyan Cat™ inspired, can you please change its color?"],
	["Design & Engineering", "Mr. Whiskers! I want my car to have suspensions to experience cloud 9."],
	["Material Reworking", "Mr. Whiskers! How will I know what materials will be used for my car?"]
]

var current_q = 0

onready var description = get_node("%Question")
onready var buttons_container = get_node("%Buttons")
onready var animplayer = $AnimationPlayer

func _ready():
	get_node("/root/StateMachine").pause_level_timer()
	animplayer.play("RESET")
	for button in buttons_container.get_children():
		button.connect('pressed', self, '_on_button_pressed', [button])

	randomize()
	processes.shuffle()
	show_question()

func show_question():
	if current_q >= len(processes):
		get_node("/root/StateMachine").level_done()
		return
	animplayer.play("show_dialogue")
	description.bbcode_text = "[center]" + processes[current_q][1]

	var buttons = buttons_container.get_children()
	buttons.shuffle()
	var choices = one_nonrandom_element(current_q, len(buttons), processes)
	for button_index in range(len(buttons)):
		var button = buttons[button_index]
		button.text = choices[button_index][0]
	

func _on_button_pressed(button):
	var choice = button.text
	var answer = processes[current_q][0]
	if choice == answer:
		get_node("/root/StateMachine").level_done()
		#current_q += 1
		#show_question()
	else:
		get_node("/root/StateMachine").penalize()
		animplayer.play("wrong")
		pass

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

func start_timer():
	get_node("/root/StateMachine").continue_level_timer()