extends Node2D

signal load_eight(system)

var buttons = []
var queue_system

func setup(scenario : Array):
    $Car.texture = load(scenario[1])
    get_buttons()

func get_buttons():
    for child in $CanvasLayer/Control.get_children():
        if child is Button:
            buttons.append(child)
            child.connect("pressed", self, "pressed", [child])

func pressed(btn):
    $CanvasLayer/Control/ConfirmationDialog.visible = true
    queue_system = btn.text

func exit_dialog():
    $CanvasLayer/Control/ConfirmationDialog.visible = false

func _on_No_pressed():
    queue_system = null
    exit_dialog()

func _on_Yes_pressed():
    emit_signal("load_eight", queue_system)
