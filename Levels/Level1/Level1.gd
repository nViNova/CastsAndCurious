extends Node2D

var intro = [
    "[color=#747474]Welcome to [b]Cats and Curious![/b][/color]",
    "[color=#747474]A [b]game[/b] where you are a cat, and you are curious![/color]",
    "[color=#747474]Oh look! someone's here? You did not notice the myeowister?[/color]",
    "[b]Mechanicat![/b]",
    "Let's test you!",
    "Identify the most probable system that failed that caused the following scenarios!",
    ["When i was going to buy catnip, my car wont [b]start properly[/b] and keeps on releasing [b]black smoke[/b]", 
        ["Engine System", "Exhaust System", "Transmission System"], "Engine System"],
    "Myeow! Good One!",
    ["I drove in the wrong [b]gear[/b] so now my clutch wont work Nya :(", 
        ["Transmission System", "Brake System", "Engine System"], "Transmission System"],
    "That's right!",
    ["My car's wiring is short [b]circuiting[/b]! its burning!",
        ["Electrical System", "Lights System", "Lubrication System"], "Electrical System"],
    "Anyather one!",
    ["Nya~ my car [b]wont slow down[/b]",
        ["Brake System","Transmission System","Lubrication System"], "Brake System"],
    "You are not cheating myeowster?",
    ["I was letting mi motorcycle go for a ride, then when i opened mi engine its parts were misplaced and now its [b]overheating[/b]",
        ["Cooling System","Fluid System","Fuel Supply System"],"Cooling System"],
    "Amyeowzing!",
    ["My [b]steering rack[/b] is jerking when going over bumps",
        ["Steering System","Transmission System","Lubrication System"], "Steering System"],
    "Good job!",
    ["I am hearing a weird loud noise from the [b]nether regions[/b] of mi car Nyah!",
        ["Exhaust System","Engine System","Transmission System"], "Exhaust System"],
    "Myeow! Good One!",
    ["My car is leaking so much [b]gasoline[/b]",
        ["Fuel Supply System","Cooling System","Engine System"],"Fuel Supply System"],
    "That's right!",
    ["Whenever i do a signal to the right, my car displays a left signal [b]light![/b]",
        ["Light System", "Electric System", "Brake System"], "Light System"],
    "Last one!",
    ["The two rods in my engine are [b]rubbing together[/b] and are getting worn out",
        ["Lubrication System", "Engine System", "Cooling System"], "Lubrication System"],
    "[b]AMYEOOOOOWZING![/b]",
    "You did an excellent job nya!"
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