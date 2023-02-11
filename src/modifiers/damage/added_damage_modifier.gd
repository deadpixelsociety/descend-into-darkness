extends StatModifier
class_name AddedDamageModifier


func _add_custom_template_data(data: Dictionary, template_value: float) -> Dictionary:
	var min_modifier = submodifiers[0]
	var max_modifier = submodifiers[1]
	data["plus1"] = "+" if min_modifier.value >= 0.0 else "-"
	data["plus2"] = "+" if max_modifier.value >= 0.0 else "-"
	data["value1"] = min_modifier._get_value_str(min_modifier.value)
	data["value2"] = max_modifier._get_value_str(max_modifier.value)
	return data
