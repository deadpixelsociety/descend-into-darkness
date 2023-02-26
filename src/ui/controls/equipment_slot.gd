extends InventorySlot
class_name EquipmentSlot

@export var hero_index: int:
	set(value):
		hero_index = value
		_hero = Party.get_hero(hero_index)

@export var equipment_type: ItemConstants.EquipmentType
@export var hint_texture: Texture2D:
	set(value):
		hint_texture = value
		_setup_slot()

var _hero: Hero

@onready var _hint: TextureRect = %Hint


func can_equip_here(other: ItemDefinition) -> bool:
	if not _hero or not _hero.can_equip_item(other):
		return false
	var valid = ItemConstants.EQUIPMENT_MAP[equipment_type].has(other.item_type)
	if valid:
		return true
	if ItemConstants.WEAPON_TYPES.has(other.item_type):
		var weapon_base = other.item_base as WeaponBase
		if weapon_base and not weapon_base.two_handed:
			if _hero.hero_class.can_dual_wield:
				var weapon = _hero.get_equipped_item(ItemConstants.EquipmentType.WEAPON)
				if weapon and weapon.item_base.two_handed:
					return false
				return ItemConstants.DUAL_WIELD_TYPES.has(equipment_type)
	return false



func _equip_item():
	if _hero and item_def:
		_hero.equip_item(equipment_type, item_def)


func _unequip_item():
	if _hero and item_def:
		_hero.unequip_item(equipment_type, item_def)


func _can_drop_data(at_position: Vector2, data) -> bool:
	var can_drop = false
	if data is Dictionary and data.has("item_def"):
		var def = data["item_def"] as ItemDefinition
		can_drop = can_equip_here(def)
	modulate = Color.RED if not can_drop else Color.GREEN
	return can_drop


func _drop_data(at_position: Vector2, data):
	super._drop_data(at_position, data)
	modulate = Color.WHITE


func _setup_slot():
	super._setup_slot()
	_hero = Party.get_hero(hero_index)
	if _hint:
		_hint.texture = hint_texture
		_hint.visible = item_def == null


func _on_item_def_changing():
	_unequip_item()


func _on_item_def_changed():
	_equip_item()


func _on_mouse_exited() -> void:
	if not NodeUtil.is_mouse_inside(self):
		modulate = Color.WHITE
