extends HBoxContainer
class_name HeroContainer

@export var hero_index: int = 0
@export var portrait_repository: PortraitRepository

var _hero: Hero

@onready var _portrait: PortraintContainer = %Portrait
@onready var _health_vial: ResourceVial = %HealthVial
@onready var _mana_vial: ResourceVial = %ManaVial
@onready var _hero_name: Label = %HeroName
@onready var _hero_class: Label = %HeroClass
@onready var _level: Label = %Level
@onready var _leader: Label = %Leader
@onready var _health: Label = %Health
@onready var _mana: Label = %Mana
@onready var _bleed_status: PanelContainer = %BleedStatus
@onready var _burn_status: PanelContainer = %BurnStatus
@onready var _poison_status: PanelContainer = %PoisonStatus
@onready var _shock_status: PanelContainer = %ShockStatus
@onready var _chill_status: PanelContainer = %ChillStatus


func _ready():
	Party.hero_data_changed.connect(_on_hero_data_changed)
	Party.hero_health_changed.connect(_on_hero_health_changed)
	Party.hero_mana_changed.connect(_on_hero_mana_changed)
	_portrait.portrait_repository = portrait_repository
	_hero = Party.get_hero(hero_index)
	_setup_hero()


func _setup_hero():
	if not _hero:
		return
	if _portrait:
		var portrait_data = Party.get_portrait(_hero)
		_portrait.set_portrait_data(Party.get_portrait(_hero))
	if _hero_name:
		_hero_name.text = Party.get_hero_name(_hero)
	if _hero_class:
		_hero_class.text = _hero.hero_class.hero_tag
		_hero_class.label_settings.outline_color = _hero.hero_class.hero_color
		_hero_class.label_settings.shadow_color = _hero.hero_class.hero_color
		_hero_class.label_settings.shadow_color.a = 0.25
	if _level:
		_level.text = "Lv. %d" % Party.get_level()
	if _leader:
		_leader.visible = Party.get_leader() == _hero


func _update_health(value_max: float, value_current: float):
	if _health_vial:
		var health = 0.0 if value_max <= 0.0 else value_current / value_max
		_health_vial.tween_resource_value(health)
	if _health:
		_health.text = "H %3d/%d" % [ floor(value_current), floor(value_max) ]


func _update_mana(value_max: float, value_current: float):
	if _mana_vial:
		var mana = 0.0 if value_max <= 0.0 else value_current / value_max
		_mana_vial.tween_resource_value(mana)
	if _mana:
		_mana.text = "M %2d/%d" % [ floor(value_current), floor(value_max) ]


func _on_hero_data_changed(index: int, hero: Hero):
	if index != hero_index:
		return
	_hero = hero
	_setup_hero()


func _on_hero_health_changed(hero: Hero, value_max: float, value_current: float):
	if hero != Party.get_hero(hero_index):
		return
	_update_health(value_max, value_current)


func _on_hero_mana_changed(hero: Hero, value_max: float, value_current: float):
	if hero != Party.get_hero(hero_index):
		return
	_update_mana(value_max, value_current)
