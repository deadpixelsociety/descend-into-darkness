extends Control
class_name UI

@onready var _inventory_panel: Control = %InventoryPanel
@onready var _inventory_slots: InventorySlots = %InventorySlots


func _ready():
	EventBus.ui_ready.emit()


func _can_drop_data(at_position: Vector2, data) -> bool:
	if data is ItemDefinition:
		return true
	return false


func _drop_data(at_position: Vector2, data):
	if data is ItemDefinition:
		EventBus.item_dropped.emit(data)
		_inventory_slots.clear_item(data)


func _on_inventory_button_pressed() -> void:
	_inventory_panel.modulate.a = 0.0
	_inventory_panel.visible = not _inventory_panel.visible
	var tween = create_tween().bind_node(self)
	tween.tween_property(
		_inventory_panel,
		"modulate:a",
		1.0,
		0.1
	)
	tween.play()
