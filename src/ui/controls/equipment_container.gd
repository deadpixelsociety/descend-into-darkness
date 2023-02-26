extends Control
class_name EquipmentContainer

@export var hero_index: int:
	set(value):
		hero_index = value
		_hero = Party.get_hero(hero_index)
		_set_hero()

var _dragging: bool = false
var _hero: Hero

@onready var _slots: Dictionary = {
	ItemConstants.EquipmentType.WEAPON: %Weapon,
	ItemConstants.EquipmentType.OFFHAND: %Offhand,
	ItemConstants.EquipmentType.HELM: %Helm,
	ItemConstants.EquipmentType.CHEST: %Chest,
	ItemConstants.EquipmentType.BOOTS: %Boots,
	ItemConstants.EquipmentType.NECKLACE: %Necklace,
	ItemConstants.EquipmentType.RING: %Ring,
}


func _ready():
	#Party.hero_equipment_changed.connect(_on_hero_equipment_changed)
	pass


func _process(delta: float):
	if _dragging and not NodeUtil.is_mouse_inside(self):
		_on_mouse_exited()


func equip_items(data: Dictionary):
	for type in ItemConstants.EquipmentType:
		var idx = ItemConstants.EquipmentType[type]
		var slot = _slots[idx] as EquipmentSlot
		slot.raise_events = false
		if data.has(idx):
			slot.item_def = data[idx]
		else:
			slot.item_def = null
		slot.raise_events = true


func _set_hero():
	if _slots:
		for slot in _slots.values():
			if slot:
				slot.hero_index = hero_index


func _can_drop_data(at_position: Vector2, data) -> bool:
	_dragging = true
	if data is Dictionary and data.has("item_def"):
		var slots = _get_equipment_slots(data["item_def"])
		if slots.size() == 0:
			return false
		var can_equip = false
		for slot in slots:
			if slot.can_equip_here(data["item_def"]):
				slot.modulate = Color.GREEN
				can_equip = true
		return can_equip
	return false


func _drop_data(at_position: Vector2, data):
	_dragging = false
	var sender = data["sender"]
	var item_def = data["item_def"] as ItemDefinition
	var slots = _get_equipment_slots(item_def)
	var equipped = false
	# Try to equip in an empty slot first
	for slot in slots:
		if slot.can_equip_here(item_def) and slot.item_def == null:
			slot._drop_data(at_position, data)
			equipped = true
			break
	if not equipped:
		for slot in slots:
			if slot.can_equip_here(item_def):
				slot._drop_data(at_position, data)
				break
	for slot in slots:
		slot.modulate = Color.WHITE


func _get_equipment_slots(item_def: ItemDefinition) -> Array[EquipmentSlot]:
	var list: Array[EquipmentSlot] = []
	var valid_slots = _hero.get_valid_slots(item_def)
	for _slot in _slots.values():
		var slot = _slot as EquipmentSlot
		if valid_slots.has(slot.equipment_type):
			list.append(slot)
	return list


func _on_hero_equipment_changed(hero: Hero):
	var index = Party.get_hero_index(hero)
	if index == hero_index:
		equip_items(hero.get_equipment())


func _on_mouse_exited():
	if not NodeUtil.is_mouse_inside(self):
		_dragging = false
		for slot in _slots.values():
			slot.modulate = Color.WHITE
