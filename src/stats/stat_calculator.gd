class_name StatCalculator


static func calculate_dps(stats: Stats) -> float:
	var avg_hit = (stats.damage_min + stats.damage_max) / 2.0
	var crit_chance = min(max(0.0, stats.critical_chance / 100.0), 1.0)
	var crit_bonus = max(0.0, stats.critical_bonus / 100.0)
	var non_crit_damage = (1.0 - crit_chance) * avg_hit
	var crit_damage = (crit_chance * avg_hit) * crit_bonus
	return (non_crit_damage + crit_damage) * stats.attack_speed


static func calculate_hit(stats: Stats) -> DamageCalcResult:
	var result = DamageCalcResult.new()
	result.is_crit = randf() <= (stats.critical_chance / 100.0)
	var hit = randf_range(stats.damage_min, stats.damage_max)
	if result.is_crit:
		hit *= (stats.critical_bonus / 100.0)
	result.damage = roundf(hit)
	return result


static func calculate_health_max(modifiers: Array[Modifier]) -> float:
	return _calculate_stat(modifiers, StatConstants.StatType.HEALTH_MAX)


static func calculate_health_regen(modifiers: Array[Modifier]) -> float:
	return _calculate_stat(modifiers, StatConstants.StatType.HEALTH_REGEN)


static func calculate_mana_max(modifiers: Array[Modifier]) -> float:
	return _calculate_stat(modifiers, StatConstants.StatType.MANA_MAX)


static func calculate_attack_speed(modifiers: Array[Modifier]) -> float:
	return _calculate_stat(modifiers, StatConstants.StatType.ATTACK_SPEED)


static func calculate_min_damage(modifiers: Array[Modifier]) -> float:
	return _calculate_damage_stat(modifiers, StatConstants.StatType.DAMAGE_MIN)


static func calculate_max_damage(modifiers: Array[Modifier]) -> float:
	return _calculate_damage_stat(modifiers, StatConstants.StatType.DAMAGE_MAX)


static func calculate_spell_power(modifiers: Array[Modifier]) -> float:
	return _calculate_stat(modifiers, StatConstants.StatType.SPELL_POWER)


static func calculate_critical_chance(modifiers: Array[Modifier]) -> float:
	return _calculate_stat(modifiers, StatConstants.StatType.CRITICAL_CHANCE)


static func calculate_critical_bonus(modifiers: Array[Modifier]) -> float:
	return _calculate_stat(modifiers, StatConstants.StatType.CRITICAL_BONUS)


static func calculate_area_of_effect(modifiers: Array[Modifier]) -> float:
	return _calculate_stat(modifiers, StatConstants.StatType.AREA_OF_EFFECT)


static func calculate_block(modifiers: Array[Modifier]) -> float:
	return _calculate_stat(modifiers, StatConstants.StatType.BLOCK)


static func calculate_defense(modifiers: Array[Modifier]) -> float:
	return _calculate_stat(modifiers, StatConstants.StatType.DEFENSE)


static func calculate_evasion(modifiers: Array[Modifier]) -> float:
	return _calculate_stat(modifiers, StatConstants.StatType.EVASION)


static func calculate_movement_speed(modifiers: Array[Modifier]) -> float:
	return _calculate_stat(modifiers, StatConstants.StatType.MOVEMENT_SPEED)


static func calculate_leech(modifiers: Array[Modifier]) -> float:
	return _calculate_stat(modifiers, StatConstants.StatType.LEECH)


static func calculate_burn(modifiers: Array[Modifier]) -> float:
	return _calculate_stat(modifiers, StatConstants.StatType.BURN)


static func calculate_bleed(modifiers: Array[Modifier]) -> float:
	return _calculate_stat(modifiers, StatConstants.StatType.BLEED)


static func calculate_poison(modifiers: Array[Modifier]) -> float:
	return _calculate_stat(modifiers, StatConstants.StatType.POISON)


static func calculate_shock(modifiers: Array[Modifier]) -> float:
	return _calculate_stat(modifiers, StatConstants.StatType.SHOCK)


static func calculate_chill(modifiers: Array[Modifier]) -> float:
	return _calculate_stat(modifiers, StatConstants.StatType.CHILL)


static func _calculate_stat(modifiers: Array[Modifier], type: StatConstants.StatType) -> float:
	var base = 0.0
	var increased = 0.0
	var multiplier = 0.0
	
	for modifier in modifiers:
		if modifier is StatModifier:
			if modifier.stat_type == type:
				if modifier.modifier_type == StatConstants.ModifierType.BASE:
					base += modifier.get_adjusted_value()
				elif modifier.modifier_type == StatConstants.ModifierType.INCREASED:
					increased += modifier.get_adjusted_value()
				elif modifier.modifier_type == StatConstants.ModifierType.MULTIPLIER:
					multiplier += modifier.get_adjusted_value()
	
	var stat = (base + (base * increased))
	if multiplier != 0.0:
		stat *= multiplier
	return stat


static func _calculate_damage_stat(modifiers: Array[Modifier], type: StatConstants.StatType) -> float:
	var base = 0.0
	var increased = 0.0
	var multiplier = 0.0
	var damage_increased = 0.0
	var damage_multiplier = 0.0
	
	for modifier in modifiers:
		if modifier is StatModifier:
			if modifier.stat_type == type:
				if modifier.modifier_type == StatConstants.ModifierType.BASE:
					base += modifier.get_adjusted_value()
				elif modifier.modifier_type == StatConstants.ModifierType.INCREASED:
					increased += modifier.get_adjusted_value()
				elif modifier.modifier_type == StatConstants.ModifierType.MULTIPLIER:
					multiplier += modifier.get_adjusted_value()
			if modifier.stat_type == StatConstants.StatType.DAMAGE:
				if modifier.modifier_type == StatConstants.ModifierType.INCREASED:
					damage_increased += modifier.get_adjusted_value()
				elif modifier.modifier_type == StatConstants.ModifierType.MULTIPLIER:
					damage_multiplier += modifier.get_adjusted_value()
	
	var stat = (base + (base * increased))
	if multiplier != 0.0:
		stat *= multiplier
	stat = (stat + (stat * damage_increased))
	if damage_multiplier != 0.0:
		stat *= damage_multiplier
	return stat
