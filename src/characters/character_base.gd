extends CharacterBody2D
class_name CharacterBase

@export var effect_container: Node2D
@export var stats: Stats

var id: String = Guid.generate()

var _modifiers: Array[Modifier] = []
var _stat_modifiers: Dictionary = {}
var _on_hit_modifiers: Array[OnHitModifier] = []


func get_stats() -> Stats:
	return stats


func deal_damage(target: Node2D):
	var result = StatCalculator.calculate_hit(get_stats())
	if target.has_method("take_damage"):
		var damage_dealt = target.take_damage(self, result.damage, result.is_crit)
		if damage_dealt > 0.0:
			apply_on_hit(target)


func apply_on_hit(target: Node2D):
	if not target.has_method("add_effect"):
		return
	for modifier in get_on_hit_modifiers():
		target.add_effect(self, modifier)


func take_damage(damager: Node2D, damage: float, is_crit: bool) -> float:
	return damage


func add_effect(applicator: Node2D, modifier: OnHitModifier):
	if not modifier.can_apply_effect(self) or not modifier.on_hit_effect:
		return
	var effect = modifier.on_hit_effect.instantiate() as OnHitEffect
	effect_container.add_child(effect)
	effect.apply_effect(modifier, applicator, self)


func get_effects() -> Array[OnHitEffect]:
	var list: Array[OnHitEffect] = []
	for child in effect_container.get_children():
		var effect = child as OnHitEffect
		if effect:
			list.append(effect)
	return list


func apply_modifier(modifier: Modifier, calculate: bool = true, recalculate_stats: bool = true):
	_modifiers.append(modifier)
	if modifier is StatModifier:
		_store_stat_modifier(modifier)
		if calculate:
			modifier.calculate()
	if modifier is OnHitModifier:
		_on_hit_modifiers.append(modifier)
	if recalculate_stats:
		_recalculate_stats()


func remove_modifiers(owner_id: String):
	for i in range(_modifiers.size() - 1, -1, -1):
		var modifier = _modifiers[i] as Modifier
		if modifier.owner_id == owner_id:
			_modifiers.remove_at(i)
			if modifier is StatModifier:
				_remove_stat_modifier(modifier)
			if modifier is OnHitModifier:
				_on_hit_modifiers.erase(modifier)
	_recalculate_stats()


func get_modifiers() -> Array[Modifier]:
	return _modifiers


func get_stat_modifiers() -> Array[StatModifier]:
	var list: Array[StatModifier] = []
	for key in _stat_modifiers.keys():
		list.append_array(Collections.get_dict_array(_stat_modifiers, key))
	return list


func get_on_hit_modifiers() -> Array[OnHitModifier]:
	return _on_hit_modifiers


func _store_stat_modifier(modifier: StatModifier):
	if not _stat_modifiers.has(modifier.stat_type):
		_stat_modifiers[modifier.stat_type] = Array()
	var list = _stat_modifiers[modifier.stat_type] as Array
	list.append(modifier)
	_stat_modifiers[modifier.stat_type] = list


func _remove_stat_modifier(modifier: StatModifier):
	if not _stat_modifiers.has(modifier.stat_type):
		return
	var list = _stat_modifiers[modifier.stat_type] as Array
	list.erase(modifier)
	_stat_modifiers[modifier.stat_type] = list


func _recalculate_stats():
	var stats = get_stats()
	if stats:
		stats.calculate(_modifiers)
