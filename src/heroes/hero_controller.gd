extends RefCounted
class_name HeroController

var _hero: Hero


func _init(hero: Hero):
	_hero = hero


func process(delta: float):
	pass


func get_hero() -> Hero:
	return _hero
