@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btaction.png")
extends BTAction
class_name ActionChaseHero

@export var min_distance: float = 10.0


func tick(actor: Node, blackboard: BTBlackboard) -> int:
	var target = blackboard.get_data("target")
	var dist = actor.position.distance_to(target.position)
	if dist <= min_distance:
		return BTTickResult.SUCCESS
	
	var dir = actor.position.direction_to(target.position)
	if actor.has_method("move"):
		actor.move(dir)
		return BTTickResult.RUNNING
	
	return BTTickResult.FAILURE
