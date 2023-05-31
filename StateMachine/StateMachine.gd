extends Node

var current_state
var scenes = [
	["Fixing the Purr-oblem!", "res://Levels/Level1/Level1.tscn", 6],
	["Boxing It Out!", "res://Levels/Level2/Level2.tscn", 12],
	["Paws, Pads, Parts", "res://Levels/Level3/Level3.tscn", 6],
	["Automotive Manu-Cattery", "res://Levels/Level4/Level4.tscn", 6],
	["Fix-It Felines!", "res://Levels/Level5/Level5.tscn", 6],
	["Tabby Tools", "res://Levels/Level6/Level6.tscn", 24]
]
onready var fail_scene = load("res://MainMenu/GameOver.tscn")
onready var main_scene = load("res://MainMenu/MainMenu.tscn")
var loaded_scenes = []
var current_scene_i = 0
var current_scene : PackedScene
var current_scene_name : String
var score = 0
#multiply this to time
var difficulty_scale = 1
var lives = 3

func _ready():
	randomize()
	#uncomment this to shuffle the levels
	scenes.shuffle()
	for scene in scenes:
		loaded_scenes.append(load(scene[1]))
	current_scene = loaded_scenes[0]
	current_scene_name = scenes[current_scene_i][0]
	$AnimationPlayer.play("hide")

func start():
	#get_tree().change_scene_to(current_scene)
	$CanvasLayer/Control/VSplitContainer/Label.text = current_scene_name
	$AnimationPlayer.play("transition")
#Make the level call this when it's done

func level_done():
	#score += (level max time + time left) * 10
	score += int((scenes[current_scene_i][2] + $LevelTimer.get_time_left()) * 10)
	$LevelTimer.reset()

	current_scene_i += 1
	if current_scene_i >= len(loaded_scenes):
		difficulty_scale = difficulty_scale * 0.7
		current_scene_i = 0
	current_scene_name = scenes[current_scene_i][0]
	$CanvasLayer/Control/VSplitContainer/Label.text = "Current Score: " + str(score) + "\n" + current_scene_name + "\nLives: " + str(lives)
	$AnimationPlayer.play("transition")

func level_failed():
	lives += -1
	if lives <= 0:
		get_tree().change_scene_to(fail_scene)
	else:
		level_done()

func change_scene():
	get_tree().change_scene_to(loaded_scenes[current_scene_i])

#call this whenever the level should be started
func start_level_timer():
	$LevelTimer.start_timer(scenes[current_scene_i][2] * difficulty_scale)

func pause_level_timer():
	$LevelTimer.pause_timer()

func continue_level_timer():
	$LevelTimer.continue_timer()

func _on_LevelTimer_timeout():
	#get_tree().quit() #LMAO
	$LevelTimer.reset()
	level_failed()

func penalize():
	$LevelTimer.penalize()