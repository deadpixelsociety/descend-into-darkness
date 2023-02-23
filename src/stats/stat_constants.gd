class_name StatConstants

enum StatCategory {
	HEALTH,
	OFFENSE,
	DEFENSE,
	MISC,
	MANA
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
	CHILL,
	MANA_MAX
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
	StatType.ATTACK_SPEED : "res://assets/textures/stats/attack_speed.png",
	StatType.DAMAGE : "res://assets/textures/stats/damage.png",
	#StatType.DAMAGE_MIN : "",
	#StatType.DAMAGE_MAX : "",
	StatType.CRITICAL_CHANCE : "res://assets/textures/stats/critical_strike_chance.png",
	StatType.CRITICAL_BONUS : "",
	StatType.BLOCK : "res://assets/textures/stats/block.png",
	#StatType.DEFENSE : "",
	StatType.EVASION : "res://assets/textures/stats/evasion.png",
	StatType.MOVEMENT_SPEED : "res://assets/textures/stats/movement_speed.png",
	StatType.AREA_OF_EFFECT : "res://assets/textures/stats/area_of_effect.png",
	StatType.SPELL_POWER : "res://assets/textures/stats/spell_power.png",
	StatType.LEECH : "res://assets/textures/stats/leech.png",
	StatType.BURN : "res://assets/textures/stats/burn.png",
	StatType.BLEED : "res://assets/textures/stats/bleed.png",
	StatType.POISON : "res://assets/textures/stats/poison.png",
	StatType.SHOCK : "res://assets/textures/stats/shock.png",
	StatType.CHILL : "res://assets/textures/stats/chill.png",
	StatType.MANA_MAX : "res://assets/textures/stats/mana_max.png"
}
