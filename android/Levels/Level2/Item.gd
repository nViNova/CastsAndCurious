extends Sprite

enum Boxes {LEFT, RIGHT}

signal set_down

export(Boxes) var box = Boxes.LEFT

var drag = false

var draggable = true
var accept_input = true


func init_item(name,texture,_box):
	self.texture = texture
	self.box = _box
	get_node("Label").text = name
	if box == Boxes.LEFT:
		#material.set_shader_param('overlay_color', Color.red)
		modulate = Color.red
	else:
		#material.set_shader_param('overlay_color', Color.blue)
		modulate = Color.blue
	return self

func _unhandled_input(event):
    if not accept_input:
        return
    if event is InputEventScreenTouch:
        if get_rect().has_point(to_local(event.position)):
            drag = event.pressed
            get_tree().root.set_input_as_handled()
    $Label.visible = drag
    if event is InputEventScreenDrag and drag:
        position = event.position
        get_tree().root.set_input_as_handled()

func _process(_delta):
    if not drag and not draggable:
        accept_input = false
        emit_signal("set_down")
        set_process(false)
