extends Node2D

func _ready():
    get_node("/root/StateMachine").scenes.shuffle()
    get_node("/root/StateMachine").lives = 3
    $AnimationPlayer.play("dissolve_in")

func quit():
    get_tree().quit()

func start():
	$AnimationPlayer.play("dissolve_out")

func call_sm():
    get_node("/root/StateMachine").start()
