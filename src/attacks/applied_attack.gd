extends Node2D
class_name AppliedAttack

@export var attack_offset: float = 24.0

var _attack: Attack
var _hero: Hero
var _target: Vector2
var _weapon: ItemDefinition


func _ready():
	Party.hero_data_changed.connect(_on_hero_data_changed)


func setup_attack(hero: Hero, attack: Attack, weapon: ItemDefinition):
	_hero = hero
	_attack = attack
	_weapon = weapon


func configure_attack():
	var hero = get_hero()
	if not hero:
		return
	var stats = hero.get_stats()
	if stats:
		if stats.area_of_effect != 0.0:
			scale *= (1.0 + (stats.area_of_effect / 100.0))


func can_attack() -> bool:
	return true


func attack():
	pass


func get_hero() -> Hero:
	return _hero


func get_attack_def() -> Attack:
	return _attack


func get_weapon() -> ItemDefinition:
	return _weapon


func set_target(target: Vector2):
	_target = target


func get_target() -> Vector2:
	return _target


func set_offset_position():
	var hero = get_hero()
	if not hero:
		return
	var dir = hero.global_position.direction_to(get_target())
	global_position = hero.global_position + (dir * attack_offset)


func _on_hero_data_changed(hero_index: int, hero: Hero):
	if hero == get_hero():
		configure_attack()
