extends Node2D

var intro = [
    "so uh hi!",
    "welcome to [b]Cats and Curious![/b]",
    "I need your help!",
    "help me solve the following problems!",
    ["My x is broken? how do I fix it?", ["x", "y", "z"], "x"],
    "Correct nya!~",
    "Thank you!",
    "But i have more problem nya!",
    ["What is the mass of the sun?", ["1kg", "...huh?", "your mom"], "1kg"],
    "That's right! the mass of the sun is a kilogram!",
    "you believe me nya?"
]
#next shown intro
var intro_i = 0
var await_game_input = false

onready var chat = $CanvasLayer/Control/Chat/RichTextLabel
onready var problem = $CanvasLayer/Control/Problem/RichTextLabel
onready var animplayer = $AnimationPlayer
onready var choices = $CanvasLayer/Control/Chat/Choices

func _ready():
    randomize()
    for btn in choices.get_children():
        btn.connect("pressed", self, "choice_pressed", [btn])
    intro_process()

func _unhandled_input(event):
    if event is InputEventScreenTouch and event.is_pressed():
        process()

func process():
    if intro_i >= len(intro):
        var sm = get_node_or_null("/root/StateMachine")
        if sm != null:
            sm.level_done()
        return
    if intro_process():
        return
    game_process()


func intro_process():
    if await_game_input:
        return false
    if intro[intro_i] is Array:
        return false
    chat.bbcode_text = "[center]" + intro[intro_i] + "[/center]"
    animplayer.play("show_text")
    intro_i += 1
    return true

func game_process():
    if await_game_input:
        return
    if not intro[intro_i] is Array:
        return
    intro[intro_i][1].shuffle()
    problem.bbcode_text = "[center]" + intro[intro_i][0] + "[/center]" 
    var buttons = choices.get_children()
    for btn_i in range(len(buttons)):
        buttons[btn_i].text = intro[intro_i][1][btn_i]
    animplayer.play("show_problem")
    await_game_input = true

func choice_pressed(btn):
    if (btn.text == intro[intro_i][2]):
        await_game_input = false
        intro_i += 1
        process()
    else:
        animplayer.play("wrong")