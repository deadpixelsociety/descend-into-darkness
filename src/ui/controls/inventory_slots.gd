extends GridContainer
class_name InventorySlots

var _slots: Array[InventorySlot] = []


func _ready():
	EventBus.item_picked_up.connect(_on_item_picked_up)
	#EventBus.item_dropped.connect(_on_item_dropped)
	_setup_slots()


func add_item(item_def: ItemDefinition) -> bool:
	var slot = get_available_slot()
	if not slot:
		return false
	slot.item_def = item_def
	return true


func clear_item(item_def: ItemDefinition) -> bool:
	var slot = find_slot_by_item(item_def)
	if not slot:
		return false
	slot.item_def = null
	return true


func find_slot_by_item(item_def: ItemDefinition) -> InventorySlot:
	for slot in _slots:
		if slot.item_def == item_def:
			return slot
	return null


func get_available_slot() -> InventorySlot:
	for slot in _slots:
		if slot.item_def == null:
			return slot
	return null


func is_slot_available() -> bool:
	return get_available_slot() != null


func _setup_slots():
	for i in get_child_count():
		var child = get_child(i) as InventorySlot
		if child:
			_slots.append(child)


func _on_item_picked_up(item_def: ItemDefinition, callback: Dictionary):
	var slot = get_available_slot()
	if not slot:
		callback["success"] = false
		return
	slot.item_def = item_def
	callback["success"] = true


func _on_item_dropped(item_def: ItemDefinition):
	clear_item(item_def)
