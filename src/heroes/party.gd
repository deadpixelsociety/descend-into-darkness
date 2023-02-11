extends Node

const MAX_LEVEL = 20
const MIN_LEVEL = 1

var _heroes: Array[Hero] = []
var _level: int = MIN_LEVEL


func add_hero(hero: Hero):
	_heroes.append(hero)
	apply_party_passives()


func remove_hero(hero: Hero):
	_heroes.erase(hero)
	unapply_party_passive(hero)


func swap_heros(a: int, b: int):
	var t = _heroes[a]
	_heroes[a] = _heroes[b]
	_heroes[b] = t


func get_heroes() -> Array[Hero]:
	return _heroes


func get_leader() -> Hero:
	if _heroes.size() == 0:
		return null
	return _heroes.front()


func get_random_hero() -> Hero:
	if _heroes.size() == 0:
		return null
	return _heroes[randi() % _heroes.size()]


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
