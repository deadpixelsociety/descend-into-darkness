@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btcondition.png")
extends BTCondition
class_name ConditionCanAttackHero


func tick(actor: Node, blackboard: BTBlackboard) -> int:
	var target = blackboard.get_data("target")
	if target and actor.has_method("can_attack"):
		var can_attack = actor.can_attack(target)
		if can_attack:
			return BTTickResult.SUCCESS
		else:
			return BTTickResult.FAILURE
	
	return BTTickResult.FAILURE
