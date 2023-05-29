extends Node2D
export var max_level_time = 1

onready var timer : Timer = get_node("Timer")
onready var progress_bar = get_node("CanvasLayer/Control/ProgressBar")

#make this an autoload and then
#call this on the start of the level
#func _ready():
#   ...
#   get_node("/root/LevelTimer")
func start():
    timer.wait_time = max_level_time
    timer.start()

func _process(delta):
    progress_bar.value = 100 * timer.time_left / timer.wait_time

func penalize(penalty:float):
    if (timer.time_left < penalty):
        timeout()
        return
    timer.start(timer.time_left - penalty)

#this timeout function can trigger game over
func timeout():
    print("LEVEL TIMED OUT")