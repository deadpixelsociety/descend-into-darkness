extends Node

var _entities_container: Node2D


func _ready():
	_entities_container = null


func get_entities_container() -> Node2D:
	if _entities_container != null:
		return _entities_container
	_entities_container = get_tree().root.find_child("Entities", true, false)
	return _entities_container


func find_nearest_group_member(from: Vector2, group: String) -> Node2D:
	var list = get_tree().get_nodes_in_group(group)
	if list.size() == 0:
		return null
	var min_dist2 = 999999.0
	var min_member: Node2D = null
	for item in list:
		var dist2 = (item.position - from).length_squared()
		if dist2 < min_dist2:
			min_dist2 = dist2
			min_member = item
	return min_member


func find_random_group_member(group: String) -> Node2D:
	var list = get_tree().get_nodes_in_group(group)
	if list.size() == 0:
		return null
	return list[randi() % list.size()]


func get_effects_of_type(target: Node2D, effect_type: OnHitModifier.OnHitType) -> Array[OnHitEffect]:
	var list: Array[OnHitEffect] = []
	if target and target.has_method("get_effects"):
		var effects = target.get_effects()
		for effect in effects:
			var on_hit_effect = effect as OnHitEffect
			if not on_hit_effect:
				continue
			if on_hit_effect.get_on_hit_type() == effect_type:
				list.append(on_hit_effect)
	return list


func get_stack_count(target: Node2D, effect_type: OnHitModifier.OnHitType) -> int:
	return get_effects_of_type(target, effect_type).size()
