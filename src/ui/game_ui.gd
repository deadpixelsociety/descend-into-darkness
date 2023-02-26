extends HBoxContainer
class_name GameUI

@onready var _item_info: ItemInfoPanel = %ItemInfoPanel
@onready var _hero_info: HeroInfoPanel  = %HeroInfoPanel
@onready var _game_container: Node = %GameContainer
@onready var _right_panel: GameRightPanel = %GameRightPanel


func _ready():
	EventBus.hero_clicked.connect(_on_hero_clicked)
	EventBus.item_hovered.connect(_on_item_hovered)
	EventBus.item_unhovered.connect(_on_item_unhovered)
	EventBus.ui_ready.emit()


func _can_drop_data(at_position: Vector2, data) -> bool:
	return data is Dictionary and data.has("item_def")


func _drop_data(at_position: Vector2, data):
	var sender = data["sender"]
	var item_def = data["item_def"] as ItemDefinition
	EventBus.item_dropped.emit(item_def)
	sender.item_def = null


func _on_item_hovered(item_def: ItemDefinition):
	_item_info.item_def = item_def
	_item_info.set_item_info_position(get_global_mouse_position())
	_item_info.show()


func _on_item_unhovered(item_def: ItemDefinition):
	if _item_info.visible and item_def == _item_info.item_def:
		_item_info.hide()


func _on_hero_clicked(hero_index: int):
	if _hero_info.visible and hero_index == _hero_info.hero_index:
		_hero_info.hide()
	else:
		_hero_info.hero_index = hero_index
		_hero_info.show()


func _on_gui_input(event: InputEvent) -> void:
	pass
#	if event is InputEventMouseButton:
#		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
#			if _hero_info.visible:
#				_hero_info.hide()
