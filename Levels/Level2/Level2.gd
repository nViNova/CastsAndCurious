extends Node2D

var positions = []
var items = []
var correct_items = 0 setget set_correct_item, get_correct_item
var item_scene = preload('res://Levels/Level2/Item.tscn')
export var brake_items = {
	"CLUTCHES":".png",
	"JOINTS":".png",
	"GEARS":".png"
}
export var hydraulic_items = {
	"OIL PUMP":".png",
	"VALVE BODY":".png",
	"ACTUATORS":".png"
}

func _ready():
	randomize()
	get_positions_in_shelf()
	for key in brake_items:
		spawn_items(key, brake_items[key], 0)
	for key in hydraulic_items:
		spawn_items(key, hydraulic_items[key], 1)
	

func get_positions_in_shelf():
	var placeholders = get_tree().get_nodes_in_group('Placeholder')
	placeholders.shuffle()
	for place in placeholders:
		positions.append(place.rect_global_position)


func spawn_items(name, path, box):
	if path == ".png":
		path = "res://icon.png" 
	var item = item_scene.instance().init_item(name,load(path),box)
	item.global_position = positions.pop_back()
	get_node("Items").add_child(item)
	items.append(item)
	item.connect("set_down", self, "item_set_down")
	


func _on_LeftArea_area_entered(area:Area2D):
	var item = area.get_parent()
	if item.box != 0:
		print('THAT SHOULD BE IN THE RIGHT BOX')
		#insert code that will kill player
		return
	item.draggable = false
	

func _on_RightArea_area_entered(area:Area2D):
	var item = area.get_parent()
	if item.box != 1:
		print('THAT SHOULD BE IN THE LEFT BOX')
		#insert code that will kill player
		return
	item.draggable = false

func _on_area_exited(area:Area2D):
	var item = area.get_parent()
	item.draggable = true

func set_correct_item(value):
	correct_items = value
	if correct_items == len(items):
		var sm = get_node_or_null("/root/StateMachine")
		if sm != null:
			sm.level_done()
		pass

func get_correct_item():
	return correct_items

func item_set_down():
	self.correct_items += 1

