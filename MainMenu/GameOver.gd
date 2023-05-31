extends Node2D
func _ready():
    $CanvasLayer/Control/StartMenu/Label.text += str(get_node("/root/StateMachine").score)
    $AnimationPlayer.play("intro")
func return():
    get_tree().change_scene_to(get_node("/root/StateMachine").main_scene)