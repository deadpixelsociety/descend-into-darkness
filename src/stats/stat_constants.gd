class_name StatConstants

enum StatCategory {
	HEALTH,
	OFFENSE,
	DEFENSE,
	MISC
}

enum StatType {
	HEALTH_MAX,
	HEALTH_REGEN,
	OBSOLETE1,
	ATTACK_SPEED,
	DAMAGE,
	DAMAGE_MIN,
	DAMAGE_MAX,
	CRITICAL_CHANCE,
	CRITICAL_BONUS,
	BLOCK,
	DEFENSE,
	EVASION,
	MOVEMENT_SPEED,
	AREA_OF_EFFECT,
	SPELL_POWER,
	LEECH,
	BURN,
	BLEED,
	POISON,
	SHOCK,
	CHILL
}

enum ValueType {
	FLAT,
	PERCENT
}

enum ModifierType {
	BASE,
	INCREASED,
	MULTIPLIER
}

const STAT_ICONS = {
	StatType.HEALTH_MAX : "res://assets/textures/stats/health_max.png",
	StatType.HEALTH_REGEN : "res://assets/textures/stats/health_regen.png",
	StatType.ATTACK_SPEED : "",
	StatType.DAMAGE : "",
	StatType.DAMAGE_MIN : "",
	StatType.DAMAGE_MAX : "",
	StatType.CRITICAL_CHANCE : "",
	StatType.CRITICAL_BONUS : "",
	StatType.BLOCK : "",
	StatType.DEFENSE : "",
	StatType.EVASION : "",
	StatType.MOVEMENT_SPEED : "",
	StatType.AREA_OF_EFFECT : "",
	StatType.SPELL_POWER : "",
	StatType.LEECH : "",
	StatType.BURN : "",
	StatType.BLEED : "",
	StatType.POISON : "",
	StatType.SHOCK : "",
	StatType.CHILL : ""
}
