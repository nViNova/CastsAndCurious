extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func SetDisplay():
	var viewPort = get_node("/root").get_child(1).get_viewport_rect().size
	var camera = get_node("/root").get_child(1).find_node("MainCamera")
	print(camera.name)
	var View_port_scale = 600/viewPort.x
	camera.set_zoom(camera.get_zoom()*View_port_scale)
	print(camera.zoom)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
