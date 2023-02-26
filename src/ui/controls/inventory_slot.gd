extends Control
class_name InventorySlot

@export var item_def: ItemDefinition:
	set(value):
		if raise_events:
			_on_item_def_changing()
		item_def = value
		if raise_events:
			_on_item_def_changed()
		_setup_slot()

var ITEM_PREVIEW: PackedScene = load("res://src/ui/controls/item_preview.tscn")

var raise_events: bool = true

var _dragging: bool = false
var _hovered: bool = false

@onready var _icon: TextureRect = %Icon


func _ready():
	_setup_slot()


func _process(delta: float):
	if (_hovered or _dragging) and not NodeUtil.is_mouse_inside(self):
		_on_icon_mouse_exited()


func _get_drag_data(at_position: Vector2):
	_dragging = true
	if not item_def:
		return null
	var data = {}
	data["sender"] = self
	data["item_def"] = item_def
	var icon = ITEM_PREVIEW.instantiate() as ItemPreview
	icon.item_def = item_def
	set_drag_preview(icon)
	return data


func _can_drop_data(at_position: Vector2, data) -> bool:
	_dragging = true
	return data is Dictionary and data.has("item_def")


func _drop_data(at_position: Vector2, data):
	_dragging = false
	var sender = data["sender"]
	var b = data["item_def"] as ItemDefinition
	var a = item_def
	sender.item_def = null
	item_def = null
	item_def = b
	sender.item_def = a


func _setup_slot():
	if _icon:
		_icon.texture = null if not item_def else item_def.item_base.icon
		_icon.modulate.a = 0.0
		var tween = create_tween().bind_node(self)
		tween.tween_property(
			_icon,
			"modulate:a",
			1.0,
			0.1
		)
		tween.play()
		await tween.finished
		#if item_def:
		#	ShaderUtil.set_shader_param(_background, "color", item_def.rarity.color)
		#ShaderUtil.set_shader_param(_background, "enabled", item_def != null)


func _on_item_def_changing():
	pass


func _on_item_def_changed():
	pass


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if item_def:
				var def = item_def
				EventBus.item_dropped.emit(def)
				item_def = null


func _on_icon_mouse_entered():
	if item_def:
		_hovered = true
		EventBus.item_hovered.emit(item_def)


func _on_icon_mouse_exited():
	if not NodeUtil.is_mouse_inside(_icon):
		_dragging = false
		_hovered = false
		EventBus.item_unhovered.emit(item_def)
