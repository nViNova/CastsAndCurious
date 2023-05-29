tool
extends Sprite
signal screen_exited

export var rep_speed = 5
var repositioning = false
onready var target = position

func setup(name, text):
    self.name = name
    $Label.text = name
    if text == ".png":
        text = "icon.png"    
    self.texture = load(text)
    return self

func screen_exited():
    emit_signal("screen_exited")

func _process(delta):
    if repositioning:
        position = position.linear_interpolate(target, rep_speed * delta)
    if position.distance_to(target) < 10:
        repositioning = false