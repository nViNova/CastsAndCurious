extends Node2D

signal timeout

onready var timer : Timer = get_node("Timer")
onready var progress_bar = get_node("CanvasLayer/Control/ProgressBar")
var max_time

func start_timer(max_time):
	self.max_time = max_time
	timer.wait_time = max_time
	timer.start()

func pause_timer():
	timer.paused = true
func continue_timer():
	timer.paused = false

func _process(delta):
	if max_time == null:
		return
	progress_bar.value = 100 - 100 * timer.time_left / max_time

func penalize():
	if max_time == null:
		return
	var penalty = .25 * max_time
	if (timer.time_left < penalty):
		timeout()
		return
	timer.start(timer.time_left - penalty)

func timeout():
	emit_signal("timeout")

func reset():
	timer.stop()
	progress_bar.value = 0
	max_time = null
func get_time_left():
	return timer.time_left
