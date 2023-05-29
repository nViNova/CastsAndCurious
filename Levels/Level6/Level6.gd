extends Node2D

var pairs = [
	["Screws", ".png", "Nail Gun and Air Wrench", ".png"],
	["Hexagon Torque Nut", ".png", "Torque Wrench", ".png"],
	["Lug Nuts", ".png", "Impact Wrench", ".png"],
]
var item_scene = preload("res://Levels/Level6/Item.tscn")

var parts = []
var tools = []

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
				return
	$AnimationPlayer.play("fail")

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
