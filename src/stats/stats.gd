extends Node
class_name Stats

const STAT_MAP = {
	StatConstants.StatType.HEALTH_MAX: "health_max",
	StatConstants.StatType.HEALTH_REGEN: "health_regen",
	StatConstants.StatType.ATTACK_SPEED: "attack_speed",
	StatConstants.StatType.DAMAGE_MIN: "damage_min",
	StatConstants.StatType.DAMAGE_MAX: "damage_max",
	StatConstants.StatType.SPELL_POWER: "spell_power",
	StatConstants.StatType.CRITICAL_CHANCE: "critical_chance",
	StatConstants.StatType.CRITICAL_BONUS: "critical_bonus",
	StatConstants.StatType.AREA_OF_EFFECT: "area_of_effect",
	StatConstants.StatType.BLOCK: "block",
	StatConstants.StatType.DEFENSE: "defense",
	StatConstants.StatType.EVASION: "evasion",
	StatConstants.StatType.MOVEMENT_SPEED: "movement_speed"
}

@export_category("Health")
@export var health_max: float = 0.0
@export var health_regen: float = 0.0
@export_category("Offense")
@export var attack_speed: float = 0.0
@export var damage_min: float = 0.0
@export var damage_max: float = 0.0
@export var spell_power: float = 0.0
@export var critical_chance: float = 0.0
@export var critical_bonus: float = 0.0
@export var area_of_effect: float = 0.0
@export_category("Defense")
@export var block: float = 0.0
@export var defense: float = 0.0
@export var evasion: float = 0.0
@export_category("Misc")
@export var movement_speed: float = 0.0


# modifiers is assumed to be a Dictionary of StatType/Array[StatModifier] pairs
func calculate(modifiers: Dictionary):
	for stat_type in StatConstants.StatType:
		var idx = StatConstants.StatType[stat_type]
		if not STAT_MAP.has(idx):
			continue
		var property = STAT_MAP[idx]
		var value = 0.0
		var data = {
			"base": 0.0,
			"increased": 0.0,
			"multiplier": 0.0
		}
		
		if modifiers.has(idx):
			var type_modifiers = modifiers[idx]
			for modifier in type_modifiers:
				modifier.accumulate(data)
			value += data["base"]
			value += data["base"] * data["increased"]
			if data["multiplier"] != 0.0:
				value *= data["multiplier"]
		
		set(property, value)


func print_stats():
	for property in STAT_MAP.values():
		var value = get(property)
		print("%s: %.02f" % [property, value])
