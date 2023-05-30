extends Sprite

enum Boxes {LEFT, RIGHT}

signal set_down

export(Boxes) var box = Boxes.LEFT

var drag = false

var accept_input = true

var correct = false

var queued_area

func init_item(name,texture,_box):
	self.texture = texture
	self.box = _box
	get_node("Label").text = name
	if box == Boxes.LEFT:
		#material.set_shader_param('overlay_color', Color.red)
		#modulate = Color.red
		pass
	else:
		#material.set_shader_param('overlay_color', Color.blue)
		#modulate = Color.blue
		pass
	return self

func _unhandled_input(event):
	if not accept_input:
		return
	if event is InputEventScreenTouch:
		if get_rect().has_point(to_local(event.position)):
			drag = event.pressed
			if drag:
				$AnimationPlayer.play("show")
			else:
				$AnimationPlayer.play("hide")
			get_tree().root.set_input_as_handled()

	if event is InputEventScreenDrag and drag:
		position = event.position
		get_tree().root.set_input_as_handled()
		

func area_entered(area:Area2D):
	queued_area = area

func area_exited(area:Area2D):
	if area == queued_area:
		queued_area = null

func _process(delta):
	if correct:
		return
	if drag:
		return
	if queued_area == null:
		return
	if (queued_area.name == "LeftArea" and box == Boxes.LEFT) or (queued_area.name == "RightArea" and box == Boxes.RIGHT):
		emit_signal("set_down")
		$AnimationPlayer.play("correct")
		set_process_unhandled_input(false)
		correct = true