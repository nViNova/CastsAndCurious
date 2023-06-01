extends Node2D

var pairs = [
	["Screws", "res://Assets/Level6/resizedScrews.png", "Air Wrench", "res://Assets/Level6/resizedAir Wrench.png"],
	["Hexagon Torque Nut", "res://Assets/Level6/resizedHexagon Torque Nut.png", "Torque Wrench", "res://Assets/Level6/resizedTorque Wrench.png"],
	["Lug Nuts", "res://Assets/Level6/resizedLug Nuts.png", "Impact Wrench", "res://Assets/Level6/resizedImpact Wrench.png"],
]
var item_scene = preload("res://Levels/Level6/Item.tscn")

var parts = []
var tools = []

func _process(delta):
	if $Parts.sprites.size() == 0 and $Tools.sprites.size() == 0:
		var sm = get_node_or_null("/root/StateMachine")
		if sm != null:
			sm.level_done()
		set_process(false)
		return

func attempt_merge():
	var part = $Parts.current_target
	var _tool = $Tools.current_target
	if part == null or _tool == null:
		return
	if not is_instance_valid(part) or not is_instance_valid(_tool):
		return
	if part.is_queued_for_deletion() or _tool.is_queued_for_deletion():
		return
	for pair in pairs:
		if pair[0] == part.name:
			#part found
			if pair[2] == _tool.name:
				part.queue_free()
				_tool.queue_free()
				$Parts.current_target = null
				$Tools.current_target = null
				
				$AnimationPlayer.play("success")
				get_node("/root/StateMachine").pause_level_timer()
				return
	$AnimationPlayer.play("fail")
	get_node("/root/StateMachine").penalize()
	get_node("/root/StateMachine").pause_level_timer()

func _ready():
	pairs.shuffle()
	for pair in pairs:
		var part = pair[0]
		var part_image_path = pair[1]
		var _tool = pair[2]
		var tool_image_path = pair[3]
		var part_instance = item_scene.instance().setup(part, part_image_path)
		var tool_instance = item_scene.instance().setup(_tool, tool_image_path)
		parts.append(part_instance)
		tools.append(tool_instance)
	parts.shuffle()
	tools.shuffle()
	for part in parts:
		$Parts.add_child(part)
	for _tool in tools:
		$Tools.add_child(_tool)
	$Parts.start()
	$Tools.start()

func continue_timer():
	get_node("/root/StateMachine").continue_level_timer()
