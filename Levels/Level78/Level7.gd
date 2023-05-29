extends Node2D

func setup(scenario : Array):
    $Sprite.texture = load(scenario[1])
    pass