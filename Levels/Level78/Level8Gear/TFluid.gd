extends Sprite

var drag = false
var reset_pos = Vector2(304, 880)
var in_area = false

func _unhandled_input(event):
    if event is InputEventScreenTouch:
        if get_rect().has_point(to_local(event.position)):
            drag = event.pressed
    if event is InputEventScreenDrag and drag:
        position += event.relative
    elif not drag:
        position = reset_pos

func _area_entered(area : Area2D):
    in_area = true

func _area_exited(area: Area2D):
    in_area = false