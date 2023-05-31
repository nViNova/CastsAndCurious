extends Node2D

onready var fluid = $TransmissionFluid
onready var gear = $Gear
onready var rust = $Gear/Rust
onready var previous_fluid_pos = position
var completion = 0
func _process(delta):
    if fluid.in_area:    
        completion += fluid.position.distance_to(previous_fluid_pos) * 0.02
        completion = clamp(completion, 0, 99)
        rust.amount = 100 - completion
    previous_fluid_pos = fluid.position
    if completion >= 99:
        set_process(false)
        var sm = get_node_or_null("/root/StateMachine")
        if sm == null:
            return
        sm.level_done()
