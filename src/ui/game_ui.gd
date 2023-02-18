extends Control
class_name GameUI

@onready var _item_info: ItemInfoControl = %ItemInfoControl
@onready var _world_render: SubViewport = %WorldRender


func _ready():
	EventBus.ui_ready.emit()
	EventBus.item_hovered.connect(_on_item_hovered)
	EventBus.item_unhovered.connect(_on_item_unhovered)


func _can_drop_data(at_position: Vector2, data) -> bool:
	return data is Dictionary and data.has("item_def")


func _drop_data(at_position: Vector2, data):
	var item_def = data["item_def"] as ItemDefinition
	EventBus.item_dropped.emit(item_def)


func _on_world_render_container_gui_input(event: InputEvent) -> void:
	_world_render.push_input(event, true)


func _on_item_hovered(item_def: ItemDefinition):
	_item_info.set_item_info_position(get_global_mouse_position())
	_item_info.item_def = item_def
	_item_info.show()


func _on_item_unhovered(item_def: ItemDefinition):
	if _item_info.visible and item_def == _item_info.item_def:
		_item_info.hide()
