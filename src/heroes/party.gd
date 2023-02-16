extends Node

signal hero_data_changed(index, hero)

const MAX_LEVEL = 20
const MIN_LEVEL = 1

var _heroes: Array[Hero] = []
var _level: int = MIN_LEVEL
var _portraits: Dictionary = {}
var _names: Dictionary = {}


func add_hero(hero: Hero):
	_heroes.append(hero)
	hero_data_changed.emit(hero, _heroes.find(hero))
	apply_party_passives()


func remove_hero(hero: Hero):
	var idx = _heroes.find(hero)
	_heroes.erase(hero)
	hero_data_changed.emit(hero, idx)
	unapply_party_passive(hero)


func swap_heros(a: int, b: int):
	var t = _heroes[a]
	_heroes[a] = _heroes[b]
	_heroes[b] = t
	hero_data_changed.emit(_heroes[a], a)
	hero_data_changed.emit(_heroes[b], b)


func get_heroes() -> Array[Hero]:
	return _heroes


func get_hero(index: int) -> Hero:
	if _heroes.size() == 0:
		return null
	return _heroes[index]


func get_leader() -> Hero:
	if _heroes.size() == 0:
		return null
	return _heroes.front()


func is_leader(hero: Hero) -> bool:
	return _heroes.size() > 0 and _heroes.front() == hero


func get_random_hero() -> Hero:
	if _heroes.size() == 0:
		return null
	return _heroes[randi() % _heroes.size()]


func get_weapon_types() -> Array[ItemConstants.ItemType]:
	var list: Array[ItemConstants.ItemType] = []
	for hero in _heroes:
		for type in ItemConstants.ItemType:
			var value = ItemConstants.ItemType[type]
			if value & hero.hero_class.weapon_type == value:
				if not list.has(value):
					list.append(value)
	return list


func get_level() -> int:
	return _level


func level_up():
	_level = clampi(_level + 1, MIN_LEVEL, MAX_LEVEL)


func get_average_movement_speed() -> float:
	if _heroes.size() == 0:
		return 0.0
	var movement_speed = 0.0
	for hero in _heroes:
		movement_speed += hero.get_stats().movement_speed
	return movement_speed / float(_heroes.size())


func get_party_position() -> Vector2:
	var pos = Vector2.ZERO
	for hero in _heroes:
		pos += hero.global_position
	return pos / float(_heroes.size())


func apply_party_passives():
	for a in _heroes:
		for b in _heroes:
			if a == b:
				continue
			if not a.hero_class or not a.hero_class.passive:
				continue
			b.apply_passive(a.hero_class.passive)


func unapply_party_passive(hero: Hero):
	if not hero.hero_class or not hero.hero_class.passive:
		return
	for other in _heroes:
		if other == hero:
			continue
		other.unapply_passive(hero.hero_class.passive)


func get_hero_index(hero: Hero) -> int:
	return _heroes.find(hero)


func set_portrait(hero: Hero, portrait: Dictionary):
	_portraits[get_hero_index(hero)] = portrait
	hero_data_changed.emit(hero, _heroes.find(hero))


func get_portrait(hero: Hero) -> Dictionary:
	var idx = get_hero_index(hero)
	if _portraits.has(idx):
		return _portraits[idx]
	return PortraitConstants.DEFAULT_PORTRAIT.duplicate()


func set_hero_name(hero: Hero, hero_name: String):
	_names[get_hero_index(hero)] = hero_name
	hero_data_changed.emit(hero, _heroes.find(hero))


func get_hero_name(hero: Hero) -> String:
	var idx = get_hero_index(hero)
	if _names.has(idx):
		return _names[idx]
	return ""
