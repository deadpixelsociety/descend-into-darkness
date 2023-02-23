@tool
extends FitContainer
class_name ItemInfoPanel

const INFO_MARGIN = 16.0

var item_def: ItemDefinition:
	set(value):
		item_def = value
		_setup_control()

var ITEM_DESCRIPTION: PackedScene = load("res://src/ui/controls/item_info_description_line.tscn")

@onready var _item_name: Label = %ItemName
@onready var _item_type: Label = %ItemType
@onready var _weapon_info: VBoxContainer = %WeaponInfo
@onready var _damage_range: Label = %DamageRange
@onready var _attack_speed: Label = %AttackSpeed
@onready var _crit_chance: Label = %CritChance
@onready var _armour_info: VBoxContainer = %ArmourInfo
@onready var _defense: Label = %Defense
@onready var _block: Label = %Block
@onready var _divider: NinePatchRect = %Divider
@onready var _description_lines: VBoxContainer = %DescriptionLines

func set_item_info_position(pos: Vector2):
	global_position = _get_item_info_position(pos)


func _setup_control():
	_item_name.text = item_def.item_name
	_item_name.modulate = item_def.rarity.color
	var type_middle = " "
	if ItemConstants.WEAPON_TYPES.has(item_def.item_type):
		var weapon_base = item_def.item_base as WeaponBase
		if weapon_base and weapon_base.two_handed:
			type_middle = " Two-Handed "
	_item_type.text = "%s%s%s" % [ item_def.rarity.rarity_name, type_middle, item_def.item_base.base_name ]
	_item_type.modulate = item_def.rarity.color
	_weapon_info.visible = ItemConstants.WEAPON_TYPES.has(item_def.item_type)
	_armour_info.visible = ItemConstants.ARMOUR_TYPES.has(item_def.item_type)
	if _weapon_info.visible:
		_damage_range.text = "Damage: %s" % item_def.get_damage_range_description()
		_attack_speed.text = "Attack Speed: %s/s" % item_def.get_attack_speed_description()
		_crit_chance.text = "Critical Chance: %s%%" % item_def.get_critical_chance_description()
	if _armour_info.visible:
		_defense.text = "Defense: %s%%" % item_def.get_defense_description()
		_block.visible = item_def.calculate_block() > 0.0
		_block.text = "Block: %s" % item_def.get_block_description()
	if item_def.description_lines.size() > 0:
		_divider.visible = true
		_description_lines.visible = true
		NodeUtil.clear_children(_description_lines)
		for line in item_def.description_lines:
			var descr = ITEM_DESCRIPTION.instantiate() as ItemInfoDescriptionLine
			_description_lines.add_child(descr)
			descr.set_description(line)
	else:
		_divider.visible = false
		_description_lines.visible = false
	update_minimum_size()


func _get_item_info_position(pos: Vector2) -> Vector2:
	var info_size = get_combined_minimum_size()
	var item_pos = pos
	var offset = Vector2(INFO_MARGIN, -info_size.y * 0.5)
	item_pos += offset
	var viewport_rect = get_viewport_rect()
	var info_rect = Rect2(item_pos, info_size)
	if info_rect.end.y > viewport_rect.end.y:
		info_rect.position.y -= (info_rect.end.y - viewport_rect.end.y)
	if info_rect.end.x > viewport_rect.end.x:
		info_rect.position.x -= (info_rect.end.x - viewport_rect.end.x)
	return info_rect.position

