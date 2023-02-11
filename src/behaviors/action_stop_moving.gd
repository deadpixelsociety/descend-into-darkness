@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btaction.png")
extends BTAction
class_name ActionStopMoving


func tick(actor: Node, blackboard: BTBlackboard) -> int:
	if actor.has_method("stop"):
		actor.stop()
		return BTTickResult.SUCCESS
	
	return BTTickResult.FAILURE
