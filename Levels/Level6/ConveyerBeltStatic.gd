tool
extends Node2D
export var speed = 100
export var bounds : Rect2 = Rect2(0,0,100,100)
onready var expression = Expression.new()
var global_offset = Vector2.ZERO

onready var sprites = filter(get_children(), "x.is_in_group(\"Level6_Items\")")
onready var offset : Vector2 setget, get_offset

var drag_relative = Vector2.ZERO
var current_target

func _ready():
    connect("child_entered_tree", self, "tree_entered")
    connect("child_exiting_tree", self, "tree_exited")

func start():
    for sprite in sprites:
        sprite.connect("screen_exited", self, "item_screen_exited", [sprite])
    reposition()
func _process(delta):
    if Engine.editor_hint:
        reposition()
    else:
        if len(sprites) == 0: return
        for sprite in sprites:
            if sprite.repositioning:
                return
        current_target = sprites[0]
        for sprite in sprites:
            sprite.position.x += drag_relative.x
            sprite.position.y = 0
            sprite.scale = Vector2.ONE
            if current_target.position.distance_to(bounds.size/2) > sprite.position.distance_to(bounds.size/2):
                current_target = sprite
        current_target.scale = Vector2.ONE * 1.3
        current_target.position.y = -50
        drag_relative = Vector2.ZERO


func _input(event):
    if event is InputEventScreenDrag:
        drag_relative = event.relative


func reposition():
    for sprite_i in range(sprites.size()):
        var sprite = sprites[sprite_i]
        sprite.target = (sprite_i * self.offset + self.offset/2)
        sprite.repositioning = true

func tree_entered(node):
    if node.is_in_group("Level6_Items"):
        sprites.append(node)
        #node.connect("screen_exited", self, "item_screen_exited", [node])

func tree_exited(node):
    if node.is_in_group("Level6_Items"):
        sprites.pop_at(sprites.find(node))
        reposition()

func item_screen_exited(sprite):
    if sprite.position.x > bounds.size.x:
        sprites.pop_at(sprites.find(sprite))
        sprites.push_front(sprite)
        sprite.position += -bounds.size
    else:
        sprites.pop_at(sprites.find(sprite))
        sprites.push_back(sprite)
        sprite.position += bounds.size
#DO NOT DELETE
func filter(array : Array, command: String):
    var new_array = []
    var error = expression.parse(command, ["x"])
    for x in array:
        if error != OK:
            print(expression.get_error_text())
            return
        var result = expression.execute([x], self, true)
        if result:
            new_array.append(x)
    return new_array

func get_offset():
    offset = bounds.size / sprites.size()
    return offset