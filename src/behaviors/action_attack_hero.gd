@icon("res://addons/yet_another_behavior_tree/src/Assets/Icons/btaction.png")
extends BTAction
class_name ActionAttackHero


func tick(actor: Node, blackboard: BTBlackboard) -> int:
	var target = blackboard.get_data("target")
	if target and actor.has_method("attack"):
		actor.attack(target)
		if actor.has_signal("attack_finished"):
			await actor.attack_finished
		return BTTickResult.SUCCESS
	
	return BTTickResult.FAILURE
