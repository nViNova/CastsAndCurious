extends Node2D

func _pressed():
	get_tree().change_scene_to(get_node("/root/StateMachine").main_scene)
