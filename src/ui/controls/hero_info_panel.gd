extends PanelContainer
class_name HeroInfoPanel

@export var hero_index: int:
	set(value):
		hero_index = value
		_setup_info()

@onready var _offense_stats: VBoxContainer = %OffenseStats
@onready var _defense_stats: VBoxContainer = %DefenseStats
@onready var _misc_stats: VBoxContainer = %MiscStats
@onready var _portrait: PortraintContainer = %Portrait
@onready var _hero_name: Label = %HeroName
@onready var _hero_class_name: Label = %HeroClassName
@onready var _level: Label = %Level
@onready var _equipment_container: EquipmentContainer = %EquipmentContainer
@onready var _dps: Label = %DPS
@onready var _damage: Label = %Damage
@onready var _spell_power: Label = %SpellPower
@onready var _attack_speed: Label = %AttackSpeed
@onready var _critical_chance: Label = %CriticalChance
@onready var _critical_bonus: Label = %CriticalBonus
@onready var _aoe: Label = %AoE
@onready var _health_max: Label = %HealthMax
@onready var _health_regen: Label = %HealthRegen
@onready var _mana_max: Label = %ManaMax
@onready var _defense: Label = %Defense
@onready var _block: Label = %Block
@onready var _evasion: Label = %Evasion
@onready var _movement_speed: Label = %MovementSpeed
@onready var _leech: Label = %Leech
@onready var _burn: Label = %Burn
@onready var _bleed: Label = %Bleed
@onready var _poison: Label = %Poison
@onready var _shock: Label = %Shock
@onready var _chill: Label = %Chill


func _ready():
	Party.hero_data_changed.connect(_on_hero_data_changed)
	_setup_info()


func _process(delta: float):
	if Input.is_action_just_pressed("ui_cancel") and visible:
		hide()


func _setup_info():
	var hero = Party.get_hero(hero_index)
	if not hero:
		return
	_update_info(hero)


func _update_info(hero: Hero):
	_portrait.set_portrait_data(Party.get_portrait(hero))
	_hero_name.text = Party.get_hero_name(hero)
	_hero_class_name.text = hero.hero_class.hero_name
	_level.text = "Lv. %d" % Party.get_level()
	_equipment_container.hero_index = hero_index
	_equipment_container.equip_items(hero.get_equipment())
	var stats = hero.get_stats()
	stats.calculate(hero.get_modifiers())
	_dps.text = "DPS: %s" % Stats.get_dps_description(stats.calculate_dps())
	_damage.text = "Damage: %s" % Stats.get_damage_range_description(stats.damage_min, stats.damage_max)
	_spell_power.text = "Spell Power: %s" % Stats.get_spell_power_description(stats.spell_power)
	_attack_speed.text = "Attack Speed: %s" % Stats.get_attack_speed_description(stats.attack_speed)
	_critical_chance.text = "Critical Chance: %s" % Stats.get_critical_chance_description(stats.critical_chance)
	_critical_bonus.text = "Critical Bonus: %s" % Stats.get_critical_bonus_description(stats.critical_bonus)
	_aoe.text = "Area of Effect: %s" % Stats.get_area_of_effect_description(stats.area_of_effect)
	_health_max.text = "Health Max: %s" % Stats.get_health_max_description(stats.health_max)
	_health_regen.text = "Health Regen: %s" % Stats.get_health_regen_description(stats.health_regen)
	_mana_max.text = "Mana Max: %s" % Stats.get_mana_max_description(stats.mana_max)
	_defense.text = "Defense: %s" % Stats.get_defense_description(stats.defense)
	_block.text = "Block: %s" % Stats.get_block_description(stats.block)
	_evasion.text = "Evasion: %s" % Stats.get_evasion_description(stats.evasion)
	_movement_speed.text = "Movement Speed: %s" % Stats.get_movement_speed_description(stats.movement_speed)
	_leech.text = "Leech: %s" % Stats.get_leech_description(stats.leech)
	_burn.text = "Burn: %s" % Stats.get_burn_description(stats.burn)
	_bleed.text = "Bleed: %s" % Stats.get_bleed_description(stats.bleed)
	_poison.text = "Poison: %s" % Stats.get_poison_description(stats.poison)
	_shock.text = "Shock: %s" % Stats.get_shock_description(stats.shock)
	_chill.text = "Chill: %s" % Stats.get_chill_description(stats.chill)


func _on_offense_pressed() -> void:
	_offense_stats.visible = true
	_defense_stats.visible = false
	_misc_stats.visible = false


func _on_defense_pressed() -> void:
	_offense_stats.visible = false
	_defense_stats.visible = true
	_misc_stats.visible = false


func _on_misc_pressed() -> void:
	_offense_stats.visible = false
	_defense_stats.visible = false
	_misc_stats.visible = true


func _on_hero_prev_pressed() -> void:
	var idx = hero_index
	idx -= 1
	if idx < 0:
		idx = Party.get_party_size() - 1
	hero_index = idx


func _on_hero_next_pressed() -> void:
	var idx = hero_index
	idx += 1
	if idx > Party.get_party_size() - 1:
		idx = 0
	hero_index = idx


func _on_hero_data_changed(index: int, hero: Hero):
	if index != hero_index:
		return
	_update_info(hero)
