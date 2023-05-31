extends Node2D

var intro = [
    ["When i was going to buy catnip, my car wont [b]start properly[/b] and keeps on releasing [b]black smoke[/b]", 
        ["Engine System", "Exhaust System", "Transmission System"], "Engine System"],
    ["I drove in the wrong [b]gear[/b] so now my clutch wont work Nya :(", 
        ["Transmission System", "Brake System", "Engine System"], "Transmission System"],
    ["My car's wiring is short [b]circuiting[/b]! its burning!",
        ["Electrical System", "Lights System", "Lubrication System"], "Electrical System"],
    ["Nya~ my car [b]wont slow down[/b]",
        ["Brake System","Transmission System","Lubrication System"], "Brake System"],
    ["I was letting mi motorcycle go for a ride, then when i opened mi engine its parts were misplaced and now its [b]overheating[/b]",
        ["Cooling System","Fluid System","Fuel Supply System"],"Cooling System"],
    ["My [b]steering rack[/b] is jerking when going over bumps",
        ["Steering System","Transmission System","Lubrication System"], "Steering System"],
    ["I am hearing a weird loud noise from the [b]nether regions[/b] of mi car Nyah!",
        ["Exhaust System","Engine System","Transmission System"], "Exhaust System"],
    ["My car is leaking so much [b]gasoline[/b]",
        ["Fuel Supply System","Cooling System","Engine System"],"Fuel Supply System"],
    ["Whenever i do a signal to the right, my car displays a left signal [b]light![/b]",
        ["Light System", "Electric System", "Brake System"], "Light System"],
    ["The two rods in my engine are [b]rubbing together[/b] and are getting worn out",
        ["Lubrication System", "Engine System", "Cooling System"], "Lubrication System"],
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
    intro.shuffle()
    get_node("/root/StateMachine").start_level_timer()
    for btn in choices.get_children():
        btn.connect("pressed", self, "choice_pressed", [btn])
    process()

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
    get_node("/root/StateMachine").pause_level_timer()
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
    get_node("/root/StateMachine").continue_level_timer()

func choice_pressed(btn):
    if (btn.text == intro[intro_i][2]):
        await_game_input = false
        intro_i += 1
        get_node("/root/StateMachine").level_done()
        #process()
    else:
        animplayer.play("wrong")
        get_node("/root/StateMachine").penalize()