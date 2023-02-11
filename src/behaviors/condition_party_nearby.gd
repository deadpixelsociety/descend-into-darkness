@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btcondition.png")
extends BTCondition
class_name ConditionPartyNearby

@export var search_range_min: float = 100.0
@export var search_range_max: float = 100.0


func tick(actor: Node, blackboard: BTBlackboard) -> int:
	var party_pos = Party.get_party_position()
	var dist = actor.position.distance_to(party_pos)
	if dist >= search_range_min and dist <= search_range_max:
		var target = Party.get_random_hero()
		blackboard.set_data("target", target)
		return BTTickResult.SUCCESS
	return BTTickResult.FAILURE
