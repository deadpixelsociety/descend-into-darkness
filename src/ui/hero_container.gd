extends HBoxContainer
class_name HeroContainer

@export var portrait_repository: PortraitRepository
@export var hero_index: int

var _hero: Hero = null

@onready var _portrait_container: PortraintContainer = %PortraitContainer
@onready var _hero_name: Label = %HeroName
@onready var _crown: TextureRect = %Crown
@onready var _health_bar: Gauge = %HealthBar


func _ready():
	EventBus.hero_health_changed.connect(_on_hero_health_changed)
	Party.hero_data_changed.connect(_on_hero_data_changed)
	if _portrait_container:
		_portrait_container.portrait_repository = portrait_repository
	_hero = Party.get_hero(hero_index)
	_setup_hero()


func _setup_hero():
	if not is_inside_tree() or not _hero:
		return
	_portrait_container.set_portrait_data(Party.get_portrait(_hero))
	_hero_name.text = Party.get_hero_name(_hero)
	_crown.visible = Party.is_leader(_hero)


func _on_hero_health_changed(hero: Hero, max: float, current: float):
	var percent = 0.0
	if max != 0.0:
		percent = clampf(current / max, 0.0, 1.0)
	_health_bar.tween_value(percent, 0.25)


func _on_hero_data_changed(hero: Hero, index: int):
	if index != hero_index:
		return
	_hero = hero
	_setup_hero()
