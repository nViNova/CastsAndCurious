extends Node

var current_state
var scenes = [
	["Fixing the Purr-oblem!", "res://Levels/Level1/Level1.tscn", 12, "Identify the problematic system"],
	["Boxing It Out!", "res://Levels/Level2/Level2.tscn", 24, "Put the parts into their category"],
	["Paws, Pads, Parts", "res://Levels/Level3/Level3.tscn", 12, "Press the part's name/function"],
	["Automotive Manu-Cattery", "res://Levels/Level4/Level4.tscn", 12, "Tap the stage of manufacturing asked"],
	["Fix-It Felines!", "res://Levels/Level5/Level5.tscn", 12, "Tap the correct worker cat"],
	["Tabby Tools", "res://Levels/Level6/Level6.tscn", 48, "Line up the tools to the part and merge!"]
]
onready var fail_scene = load("res://MainMenu/GameOver.tscn")
onready var main_scene = load("res://MainMenu/MainMenu.tscn")
var loaded_scenes = []
var current_scene_i = 0
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
	$AnimationPlayer.play("hide")
func start():
	#get_tree().change_scene_to(current_scene)
	$CanvasLayer/Control/VSplitContainer/Instructions.text = scenes[current_scene_i][0] + "\n" + scenes[current_scene_i][3]
	$AnimationPlayer.play("transition")
	$Bgroundmusic.play()
	
#Make the level call this when it's done

func level_done():
	#score += (level max time + time left) * 10
	$CatHappi.play()
	score += int((scenes[current_scene_i][2] + $LevelTimer.get_time_left()) * 10)
	$LevelTimer.reset()

	current_scene_i += 1
	if current_scene_i >= len(loaded_scenes):
		difficulty_scale = difficulty_scale * 0.7
		current_scene_i = 0
	$CanvasLayer/Control/VSplitContainer/CurrentScore.text = "Current Score: " + str(score)
	$CanvasLayer/Control/VSplitContainer/Instructions.text = scenes[current_scene_i][0] + "\n" + scenes[current_scene_i][3]
	$CanvasLayer/Control/VSplitContainer/Lives.text = "Lives: " + str(lives)
	$AnimationPlayer.play("transition")


func level_failed():
	lives += -1
	if lives <= 0:
		get_tree().change_scene_to(fail_scene)
		scenes.shuffle()
		difficulty_scale = 1
		$Bgroundmusic.stop()
	else:
		$LevelTimer.reset()
		current_scene_i += 1
		if current_scene_i >= len(loaded_scenes):
			difficulty_scale = difficulty_scale * 0.7
			current_scene_i = 0
		$CanvasLayer/Control/VSplitContainer/CurrentScore.text = "Current Score: " + str(score)
		$CanvasLayer/Control/VSplitContainer/Instructions.text = scenes[current_scene_i][0] + "\n" + scenes[current_scene_i][3]
		$CanvasLayer/Control/VSplitContainer/Lives.text = "Lives: " + str(lives)
		$AnimationPlayer.play("transition")

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
	$CatAngy.play()

func penalize():
	$CatPenalize.play()
	$LevelTimer.penalize()

func print_scenes():
	for scene in loaded_scenes:
		print(scene.resource_path)
