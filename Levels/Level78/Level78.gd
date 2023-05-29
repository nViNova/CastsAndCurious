#SCENARIO
#
extends Node2D

var scenarios = [
    ["GEARS IN TRANSMISSION",".png"],
    ["FREON LEAK IN COMPRESSOR",".png"]
]

func _ready():
    randomize()
    var scenario_i = randi() % 2
    var scenario = scenarios[scenario_i]
    $SubLevel/Level7.setup(scenario)
