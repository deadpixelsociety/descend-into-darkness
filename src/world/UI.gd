extends Control
class_name UI

@onready var _inventory_panel: Control = %InventoryPanel
@onready var _inventory_slots: InventorySlots = %InventorySlots
@onready var world_render: SubViewport = $UIContainer/CenterContainer/WorldRenderContainer/WorldRender


func _ready():
	EventBus.ui_ready.emit()


func _can_drop_data(at_position: Vector2, data) -> bool:
	return data is Dictionary and data.has("item_def")


func _drop_data(at_position: Vector2, data):
	var item_def = data["item_def"] as ItemDefinition
	EventBus.item_dropped.emit(item_def)


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


func _on_world_render_container_gui_input(event: InputEvent) -> void:
	world_render.push_input(event, true)
