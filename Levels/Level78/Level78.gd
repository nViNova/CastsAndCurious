#SCENARIO
#
extends Node2D

var scenarios = [
    ["Transmission System","res://icon.png", "res://Levels/Level78/Level8Gears.tscn"], #Gears
    ["AC System","res://icon.png", "res://Levels/Level78/Level8AC.tscn"]  #Coolant
]
var scenario
func _ready():
    randomize()
    var scenario_i = randi() % 2
    scenario = scenarios[scenario_i]
    print(scenario)
    $SubLevel/Level7.setup(scenario)

func load_eight(system):
    if system != scenario[0]:
        return
    $SubLevel/Level7.queue_free()
    $SubLevel.add_child(load(scenario[2]).instance())