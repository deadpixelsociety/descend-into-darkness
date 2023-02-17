extends Node2D

var LEECH_TRAIL: PackedScene = load("res://src/fx/leech_trail.tscn")
var BITE: PackedScene = load("res://src/fx/bite.tscn")


func add_effect(effect):
	GameUtil.get_entities_container().add_child(effect)


func leech_trail(target: Node2D, start: Vector2):
	var leech_trail = LEECH_TRAIL.instantiate() as LeechTrail
	add_effect(leech_trail)
	leech_trail.spawn(target, start)


func bite(target: Node2D):
	var bite = BITE.instantiate() as Bite
	add_effect(bite)
	print("bite spawned: ", bite)
	bite.spawn(target)
