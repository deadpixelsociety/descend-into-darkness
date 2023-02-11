extends Resource
class_name ItemDefinition

@export_category("Item")
@export var item_name: String
@export var description: String
@export var item_level: int
@export var item_type: ItemConstants.ItemType
@export var item_base: ItemBase
@export var rarity: Rarity
@export var tiers: Array[ModifierTier] = []
@export var modifiers: Array[Modifier] = []


func get_damage_range_description() -> String:
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
	return "%.0f - %.0f" % [ roundf(min_damage), roundf(max_damage) ]


func get_attack_speed_description() -> String:
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
	return "%0.2f" % attack_speed


func get_critical_chance_description() -> String:
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
	return "%0.2f" % critical_chance
