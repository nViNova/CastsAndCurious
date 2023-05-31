extends Node

var current_state
var scenes = {
	"Level 1": "res://Levels/Level1/Level1.tscn",
	"Level 2": "res://Levels/Level2/Level2.tscn",
	"Level 3": "res://Levels/Level3/Level3.tscn",
	"Level 4": "res://Levels/Level4/Level4.tscn",
	"Level 5": "res://Levels/Level5/Level5.tscn",
	"Level 6": "res://Levels/Level6/Level6.tscn"
	#insert other levels here...
}
#main menu scene or something
onready var fail_scene = load("res://MainMenu/MainMenu.tscn")
onready var win_scene = load("res://MainMenu/MainMenu.tscn")
var loaded_scenes = []
var current_scene_i = 0
var current_scene : PackedScene
var current_scene_name : String

func _ready():
	for name in scenes:
		loaded_scenes.append(load(scenes[name]))
	current_scene = loaded_scenes[0]
	current_scene_name = scenes.keys()[0]
	$AnimationPlayer.play("hide")

func start():
	#get_tree().change_scene_to(current_scene)
	$CanvasLayer/Control/VSplitContainer/Label.text = current_scene_name
	$AnimationPlayer.play("transition")
#Make the level call this when it's done

func level_done():
	current_scene_i += 1
	if current_scene_i >= len(loaded_scenes):
		get_tree().change_scene_to(win_scene)
		return
	current_scene_name = scenes.keys()[current_scene_i]
	$CanvasLayer/Control/VSplitContainer/Label.text = current_scene_name
	$AnimationPlayer.play("transition")

func level_failed():
	get_tree().change_scene_to(fail_scene)

func change_scene():
	get_tree().change_scene_to(loaded_scenes[current_scene_i])