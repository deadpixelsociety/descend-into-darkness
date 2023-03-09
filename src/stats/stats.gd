extends Node
class_name Stats

@export_category("Health")
@export var health_max: float = 0.0
@export var health_regen: float = 0.0
@export_category("Mana")
@export var mana_max: float = 0.0
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
@export_category("On Hit")
@export var leech: float = 0.0
@export var burn: float = 0.0
@export var bleed: float = 0.0
@export var poison: float = 0.0
@export var shock: float = 0.0
@export var chill: float = 0.0


static func get_dps_description(value: float) -> String:
	return Formatter.format_float(value, 2) + "/s"


static func get_health_max_description(value: float) -> String:
	return Formatter.format_float(value)


static func get_health_regen_description(value: float) -> String:
	return Formatter.format_float(value, 2) + "%"


static func get_mana_max_description(value: float) -> String:
	return Formatter.format_float(value)


static func get_attack_speed_description(value: float) -> String:
	return Formatter.format_float(value, 2) + "/s"


static func get_damage_range_description(min_value: float, max_value: float) -> String:
	return "%s - %s" % [ 
		Formatter.format_float(min_value), 
		Formatter.format_float(max_value) 
	]


static func get_spell_power_description(value: float) -> String:
	return Formatter.format_float(value) + "%"


static func get_critical_chance_description(value: float) -> String:
	return Formatter.format_float(value, 2) + "%"


static func get_critical_bonus_description(value: float) -> String:
	return Formatter.format_float(value) + "%"


static func get_area_of_effect_description(value: float) -> String:
	return Formatter.format_float(value) + "%"


static func get_block_description(value: float) -> String:
	return Formatter.format_float(value)


static func get_defense_description(value: float) -> String:
	return Formatter.format_float(value) + "%"


static func get_evasion_description(value: float) -> String:
	return Formatter.format_float(value) + "%"


static func get_movement_speed_description(value: float) -> String:
	return Formatter.format_float(value) + "%"


static func get_leech_description(value: float) -> String:
	return Formatter.format_float(value, 2) + "%"


static func get_burn_description(value: float) -> String:
	return Formatter.format_float(value) + "/s per stack"


static func get_bleed_description(value: float) -> String:
	return Formatter.format_float(value) + "/s"


static func get_poison_description(value: float) -> String:
	return Formatter.format_float(value) + "/s per stack"


static func get_shock_description(value: float) -> String:
	return Formatter.format_float(value) + "%"


static func get_chill_description(value: float) -> String:
	return Formatter.format_float(value) + "%"


func calculate(modifiers: Array[Modifier]):
	health_max = StatCalculator.calculate_health_max(modifiers)
	health_regen = StatCalculator.calculate_health_regen(modifiers)
	mana_max = StatCalculator.calculate_mana_max(modifiers)
	attack_speed = StatCalculator.calculate_attack_speed(modifiers)
	damage_min = StatCalculator.calculate_min_damage(modifiers)
	damage_max = StatCalculator.calculate_max_damage(modifiers)
	spell_power = StatCalculator.calculate_spell_power(modifiers)
	critical_chance = StatCalculator.calculate_critical_chance(modifiers)
	critical_bonus = StatCalculator.calculate_critical_bonus(modifiers)
	area_of_effect = StatCalculator.calculate_area_of_effect(modifiers)
	block = StatCalculator.calculate_block(modifiers)
	defense = StatCalculator.calculate_defense(modifiers)
	evasion = StatCalculator.calculate_evasion(modifiers)
	movement_speed = StatCalculator.calculate_movement_speed(modifiers)
	leech = StatCalculator.calculate_leech(modifiers)
	burn = StatCalculator.calculate_burn(modifiers)
	bleed = StatCalculator.calculate_bleed(modifiers)
	poison = StatCalculator.calculate_poison(modifiers)
	shock = StatCalculator.calculate_shock(modifiers)
	chill = StatCalculator.calculate_chill(modifiers)


func print_stats():
	var prop_list = get_property_list()
	for data in prop_list:
		if data["type"] == 3:
			print_debug("%s: %.02f" % [ data["name"], get(data["name"])])
