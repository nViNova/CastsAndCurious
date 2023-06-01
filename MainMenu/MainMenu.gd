extends Node2D

onready var credits_scene = load("res://MainMenu/Credits/Credits.tscn")

func _ready():
	#get_node("/root/StateMachine").scenes.shuffle()
	get_node("/root/StateMachine").lives = 3
	get_node("/root/StateMachine").score = 0
	get_node("/root/StateMachine").difficulty_scale = 1
	$AnimationPlayer.play("dissolve_in")

func quit():
	get_tree().quit()

func start():
	$AnimationPlayer.play("dissolve_out")

func call_sm():
	get_node("/root/StateMachine").start()


func credits():
	get_tree().change_scene_to(credits_scene)
