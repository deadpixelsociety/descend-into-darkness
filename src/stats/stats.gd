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
@export var leach: float = 0.0
@export var burn: float = 0.0
@export var bleed: float = 0.0
@export var poison: float = 0.0
@export var shock: float = 0.0
@export var chill: float = 0.0


func calculate(modifiers: Array[Modifier]):
	var _modifier_map = _create_modifier_map(modifiers)
	for property in _modifier_map.keys():
		var list = Collections.get_dict_array(_modifier_map, property)
		var value = 0.0
		var data = {
			"base": 0.0,
			"increased": 0.0,
			"multiplier": 0.0
		}
		
		for modifier in list:
			if modifier.has_method("accumulate"):
				modifier.accumulate(data)
		
		value += data["base"]
		value += data["base"] * data["increased"]
		if data["multiplier"] != 0.0:
			value *= data["multiplier"]
		
		set(property, value)


func _create_modifier_map(modifiers: Array[Modifier]) -> Dictionary:
	var map: Dictionary = {}
	for modifier in modifiers:
		if Strings.is_null_or_empty(modifier.modifier_property):
			continue
		assert(get(modifier.modifier_property) != null)
		var list = Collections.get_dict_array(map, modifier.modifier_property)
		list.append(modifier)
	return map


func print_stats():
	var prop_list = get_property_list()
	for data in prop_list:
		if data["type"] == 3:
			print_debug("%s: %.02f" % [ data["name"], get(data["name"])])
