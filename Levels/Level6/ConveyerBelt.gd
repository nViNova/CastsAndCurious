tool
extends Node2D
export var speed = 100
export var bounds : Rect2 = Rect2(0,0,100,100)
onready var expression = Expression.new()
var global_offset = Vector2.ZERO

onready var sprites = filter(get_children(), "x.is_in_group(\"Level6_Items\")")
onready var offset : Vector2 setget, get_offset
var current_target

func _ready():
    connect("child_entered_tree", self, "tree_entered")
    connect("child_exiting_tree", self, "tree_exited")
    
func start():
    reposition()

func _process(delta):
    if Engine.editor_hint:
        reposition()
    else:
        if len(sprites) == 0: return
        for sprite in sprites:
            sprite.scale  = Vector2.ONE
            if sprite.repositioning:
                return
        current_target = sprites[0]
        for sprite_i in range(sprites.size()):
            var sprite = sprites[sprite_i]
            sprite.position = (sprite.position + Vector2.RIGHT * speed * delta)
            if current_target.position.distance_to(bounds.size / 2) > sprite.position.distance_to(bounds.size / 2):
                current_target = sprite
        current_target.scale = Vector2.ONE * 1.2
        

func reposition():
    for sprite_i in range(sprites.size()):
        var sprite = sprites[sprite_i]
        sprite.target = (sprite_i * self.offset + self.offset/2)
        sprite.repositioning = true

func tree_entered(node):
    if node.is_in_group("Level6_Items"):
        sprites.append(node)
        node.connect("screen_exited", self, "item_screen_exited", [node])

func tree_exited(node):
    if node.is_in_group("Level6_Items"):
        sprites.pop_at(sprites.find(node))
        reposition()

func item_screen_exited(sprite):
    sprites.pop_at(sprites.find(sprite))
    sprites.push_front(sprite)
    sprite.position += -bounds.size

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