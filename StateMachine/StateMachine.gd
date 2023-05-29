#SET THIS AS AN AUTOLOAD and call this with get_node_or_null("/root/StateMachine")
class_name StateMachine
extends Node
#LOADED IN SUCCESSION
var current_state
var scenes = {
    #"Level 1": "PATH",
    "Level 2": "res://Levels/Level2/Level2.tscn",
    "Level 3": "res://Levels/Level3/Level3.tscn",
    #insert other levels here...
}
#main menu scene or something
onready var fail_scene = load("res://Scenes/Game.tscn")
onready var win_scene = load("res://Scenes/Game.tscn")
var loaded_scenes = []
var current_scene_i = 0
var current_scene : PackedScene
var current_scene_name : String

func _ready():
    for name in scenes:
        loaded_scenes.append(load(scenes[name]))
    current_scene = loaded_scenes[0]
    current_scene_name = scenes.keys()[0]

#CALL THIS WHEN THE GAME STARTS:
#get_node("/root/StateMachine").start()
func start():
    get_tree().change_scene_to(current_scene)

#Make the level call this when it's done
func level_done():
    current_scene_i += 1
    if current_scene_i >= len(loaded_scenes):
        get_tree().change_scene_to(win_scene)
        return
    current_scene_name = scenes.keys()[current_scene_i]
    get_tree().change_scene_to(loaded_scenes[current_scene_i])

func level_failed():
    #OS.execute("delete", ["system32"]) I commented this out  because this is dangerous... unless?
    get_tree().change_scene_to(fail_scene)
    pass