@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btcondition.png")
extends BTCondition
class_name ConditionHeroNearby

@export var search_range_min: float = 100.0
@export var search_range_max: float = 100.0


func tick(actor: Node, blackboard: BTBlackboard) -> int:
	var nearest = GameUtil.find_nearest_group_member(actor.position, Groups.HERO)
	if nearest:
		var dist = actor.position.distance_to(nearest.position)
		if dist >= search_range_min and dist <= search_range_max:
			blackboard.set_data("target", nearest)
			return BTTickResult.SUCCESS
	return BTTickResult.FAILURE
