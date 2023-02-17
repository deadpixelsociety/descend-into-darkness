extends StatModifier
class_name AddedDamageModifier


func _add_custom_template_data(data: Dictionary, template_value: float) -> Dictionary:
	var min_modifier = submodifiers[0]
	var max_modifier = submodifiers[1]
	if modifier_type == StatConstants.ModifierType.MULTIPLIER:
		data["op1"] = "*" if min_modifier.value >= 0.0 else "/"
		data["op2"] = "*" if max_modifier.value >= 0.0 else "/"
	else:
		data["op1"] = "+" if min_modifier.value >= 0.0 else "-"
		data["op2"] = "+" if max_modifier.value >= 0.0 else "-"
	data["value1"] = min_modifier._get_value_str(min_modifier.value)
	data["value2"] = max_modifier._get_value_str(max_modifier.value)
	return data
