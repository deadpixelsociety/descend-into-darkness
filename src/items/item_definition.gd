extends Resource
class_name ItemDefinition

@export_category("Item")
@export var item_name: String
@export var description_lines: Array[ItemDescriptionLine]
@export var item_level: int
@export var item_type: ItemConstants.ItemType
@export var item_base: ItemBase
@export var rarity: Rarity
@export var tiers: Array[ModifierTier] = []
@export var modifiers: Array[Modifier] = []


func calculate_damage_range() -> Dictionary:
	var min_damage_base = 0.0
	var min_damage_increased = 0.0
	var min_damage_multiplier = 0.0
	var max_damage_base = 0.0
	var max_damage_increased = 0.0
	var max_damage_multiplier = 0.0
	var damage_increased = 0.0
	var damage_multiplier = 0.0
	
	for modifier in modifiers:
		if modifier is StatModifier:
			if modifier.stat_type == StatConstants.StatType.DAMAGE_MIN:
				if modifier.modifier_type == StatConstants.ModifierType.BASE:
					min_damage_base += modifier.get_adjusted_value()
				elif modifier.modifier_type == StatConstants.ModifierType.INCREASED:
					min_damage_increased += modifier.get_adjusted_value()
				elif modifier.modifier_type == StatConstants.ModifierType.MULTIPLIER:
					min_damage_multiplier += modifier.get_adjusted_value()
			if modifier.stat_type == StatConstants.StatType.DAMAGE_MAX:
				if modifier.modifier_type == StatConstants.ModifierType.BASE:
					max_damage_base += modifier.get_adjusted_value()
				elif modifier.modifier_type == StatConstants.ModifierType.INCREASED:
					max_damage_increased += modifier.get_adjusted_value()
				elif modifier.modifier_type == StatConstants.ModifierType.MULTIPLIER:
					max_damage_multiplier += modifier.get_adjusted_value()
			if modifier.stat_type == StatConstants.StatType.DAMAGE:
				if modifier.modifier_type == StatConstants.ModifierType.INCREASED:
					damage_increased += modifier.get_adjusted_value()
				elif modifier.modifier_type == StatConstants.ModifierType.MULTIPLIER:
					damage_multiplier += modifier.get_adjusted_value()
	
	var level = Party.get_level()
	min_damage_base *= level
	max_damage_base *= level
	var min_damage = (min_damage_base + (min_damage_base * min_damage_increased))
	if min_damage_multiplier != 0.0:
		min_damage *= min_damage_multiplier
	var max_damage = (max_damage_base + (max_damage_base * max_damage_increased))
	if max_damage_multiplier != 0.0:
		max_damage *= max_damage_multiplier
	min_damage = (min_damage + (min_damage * damage_increased))	
	max_damage = (max_damage + (max_damage * damage_increased))
	if damage_multiplier != 0.0:
		min_damage *= damage_multiplier
		max_damage *= damage_multiplier
	return {
		"min": min_damage,
		"max": max_damage
	}


func get_damage_range_description() -> String:
	var damage = calculate_damage_range()
	return "%.0f - %.0f" % [ roundf(damage["min"]), roundf(damage["max"]) ]


func calculate_attack_speed() -> float:
	var attack_speed_base = 0.0
	var attack_speed_increased = 0.0
	var attack_speed_multiplier = 0.0
	
	for modifier in modifiers:
		if modifier is StatModifier:
			if modifier.stat_type == StatConstants.StatType.ATTACK_SPEED:
				if modifier.modifier_type == StatConstants.ModifierType.BASE:
					attack_speed_base += modifier.get_adjusted_value()
				elif modifier.modifier_type == StatConstants.ModifierType.INCREASED:
					attack_speed_increased += modifier.get_adjusted_value()
				elif modifier.modifier_type == StatConstants.ModifierType.MULTIPLIER:
					attack_speed_multiplier += modifier.get_adjusted_value()
	
	var attack_speed = (attack_speed_base + (attack_speed_base * attack_speed_increased))
	if attack_speed_multiplier != 0.0:
		attack_speed *= attack_speed_multiplier
	return attack_speed


func get_attack_speed_description() -> String:
	var attack_speed = calculate_attack_speed()
	return "%0.2f" % attack_speed


func calculate_critical_chance() -> float:
	var critical_chance_base = 0.0
	var critical_chance_increased = 0.0
	var critical_chance_multiplier = 0.0
	
	for modifier in modifiers:
		if modifier is StatModifier:
			if modifier.stat_type == StatConstants.StatType.CRITICAL_CHANCE:
				if modifier.modifier_type == StatConstants.ModifierType.BASE:
					critical_chance_base += modifier.get_adjusted_value()
				elif modifier.modifier_type == StatConstants.ModifierType.INCREASED:
					critical_chance_increased += modifier.get_adjusted_value()
				elif modifier.modifier_type == StatConstants.ModifierType.MULTIPLIER:
					critical_chance_multiplier += modifier.get_adjusted_value()
	
	var critical_chance = (critical_chance_base + (critical_chance_base * critical_chance_increased))
	if critical_chance_multiplier != 0.0:
		critical_chance *= critical_chance_multiplier
	return critical_chance


func get_critical_chance_description() -> String:
	var critical_chance = calculate_critical_chance()
	return "%0.2f" % critical_chance


func calculate_defense() -> float:
	var defense_base = 0.0
	var defense_increased = 0.0
	var defense_multiplier = 0.0
	
	for modifier in modifiers:
		if modifier is StatModifier:
			if modifier.stat_type == StatConstants.StatType.DEFENSE:
				if modifier.modifier_type == StatConstants.ModifierType.BASE:
					defense_base += modifier.get_adjusted_value()
				elif modifier.modifier_type == StatConstants.ModifierType.INCREASED:
					defense_increased += modifier.get_adjusted_value()
				elif modifier.modifier_type == StatConstants.ModifierType.MULTIPLIER:
					defense_multiplier += modifier.get_adjusted_value()
	
	var defense = (defense_base + (defense_base * defense_increased))
	if defense_multiplier != 0.0:
		defense *= defense_multiplier
	return defense


func get_defense_description() -> String:
	var defense = calculate_defense()
	return "%.0f" % defense


func calculate_block() -> float:
	var block_base = 0.0
	var block_increased = 0.0
	var block_multiplier = 0.0
	
	for modifier in modifiers:
		if modifier is StatModifier:
			if modifier.stat_type == StatConstants.StatType.BLOCK:
				if modifier.modifier_type == StatConstants.ModifierType.BASE:
					block_base += modifier.get_adjusted_value()
				elif modifier.modifier_type == StatConstants.ModifierType.INCREASED:
					block_increased += modifier.get_adjusted_value()
				elif modifier.modifier_type == StatConstants.ModifierType.MULTIPLIER:
					block_multiplier += modifier.get_adjusted_value()
	
	var block = (block_base + (block_base * block_increased))
	if block_multiplier != 0.0:
		block *= block_multiplier
	return block


func get_block_description() -> String:
	var block = calculate_block()
	return "%.0f" % block
