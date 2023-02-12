extends FitContainer
class_name ItemInfoControl

var item_def: ItemDefinition:
	set(value):
		item_def = value
		_setup_control()

var ITEM_DESCRIPTION_LABEL: PackedScene = load("res://src/items/item_description_label.tscn")

@onready var _item_name: Label = %ItemName
@onready var _weapon_info: VBoxContainer = %WeaponInfo
@onready var _damage_range: Label = %DamageRange
@onready var _attack_speed: Label = %AttackSpeed
@onready var _crit_chance: Label = %CritChance
@onready var _item_type: Label = %ItemType
@onready var _description_lines: VBoxContainer = %DescriptionLines


func _setup_control():
	_item_name.text = item_def.item_name
	_item_name.modulate = item_def.rarity.color
	_weapon_info.visible = item_def.item_type == ItemConstants.ItemType.WEAPON
	if _weapon_info.visible:
		_damage_range.text = "Damage: %s" % item_def.get_damage_range_description()
		_attack_speed.text = "Attack Speed: %s/s" % item_def.get_attack_speed_description()
		_crit_chance.text = "Critical Chance: %s%%" % item_def.get_critical_chance_description()
	_item_type.text = "%s %s" % [ item_def.rarity.rarity_name, item_def.item_base.base_name ]
	_item_type.modulate = item_def.rarity.color
	NodeUtil.clear_children(_description_lines)
	for line in item_def.description_lines:
		var label = ITEM_DESCRIPTION_LABEL.instantiate() as Label
		label.text = line
		_description_lines.add_child(label)
	update_minimum_size()
		
