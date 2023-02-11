extends Modifier
class_name StatModifier

@export_category("Stat")
@export var stat_type: StatConstants.StatType
@export var value_type: StatConstants.ValueType = StatConstants.ValueType.FLAT
@export var modifier_type: StatConstants.ModifierType = StatConstants.ModifierType.BASE
@export var stat_category: StatConstants.StatCategory
@export var min_value: float = 0.0
@export var max_value: float = 0.0

var value: float = 0.0


func accumulate(data: Dictionary):
	match modifier_type:
		StatConstants.ModifierType.BASE:
			data["base"] += get_adjusted_value()
		StatConstants.ModifierType.INCREASED:
			data["increased"] += get_adjusted_value()
		StatConstants.ModifierType.MULTIPLIER:
			data["multiplier"] += get_adjusted_value()


func get_adjusted_value() -> float:
	match value_type:
		StatConstants.ValueType.PERCENT:
			return value / 100.0
		_:
			return value


func calculate():
	value = randf_range(min_value, max_value)
	_calculate_submodifiers()


func get_description(override_value: float = 0.0) -> String:
	var template_value: float = value
	if override_value != 0.0:
		template_value = override_value
	if template_value == 0.0 and (submodifiers == null or submodifiers.size() == 0):
		return ""
	if description_template == null or not description_template.contains("{"):
		return description_template
	return description_template.format(_get_template_data(template_value))


func _get_value_str(template_value: float) -> String:
	match value_type:
		StatConstants.ValueType.PERCENT:
			return "%.f%%" % abs(template_value)
		_:
			return "%.f" % abs(template_value)


func _get_template_data(template_value: float) -> Dictionary:
	var data: Dictionary = {}
	data["value"] = _get_value_str(template_value)
	data["increased"] = "increased" if template_value >= 0.0 else "reduced"
	data["more"] = "more" if template_value >= 0.0 else "less"
	data["plus"] = "+" if template_value >= 0.0 else "-"
	return _add_custom_template_data(data, template_value)


func _add_custom_template_data(data: Dictionary, template_value: float) -> Dictionary:
	return data


func _calculate_submodifiers():
	for modifier in submodifiers:
		if modifier is StatModifier:
			modifier.calculate()
