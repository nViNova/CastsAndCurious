extends Node2D

func _ready():
    $AnimationPlayer.play("dissolve_in")

func quit():
    get_tree().quit()

func start():
	$AnimationPlayer.play("dissolve_out")

func call_sm():
    get_node("/root/StateMachine").start()
