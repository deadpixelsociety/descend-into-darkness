extends Control
class_name InventorySlot

const INFO_MARGIN = 64.0

@export var item_def: ItemDefinition:
	set(value):
		item_def = value
		_setup_slot()

@onready var _background: NinePatchRect = $Background
@onready var _icon: TextureRect = $Icon
@onready var _item_info: ItemInfoControl = $ItemInfoControl


func _ready():
	_setup_slot()


func _get_drag_data(at_position: Vector2):
	if not item_def:
		return null
	var icon = load("res://src/items/item_preview.tscn").instantiate() as ItemPreview
	icon.item_def = item_def
	set_drag_preview(icon)
	return item_def

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
		if item_def:
			ShaderUtil.set_shader_param(_background, "color", item_def.rarity.color)
		ShaderUtil.set_shader_param(_background, "enabled", item_def != null)


func _get_item_info_position() -> Vector2:
	var info_size = _item_info.get_combined_minimum_size()
	var item_pos = global_position
	var offset = Vector2(INFO_MARGIN, -info_size.y * 0.5)
	item_pos += offset
	return item_pos


func _on_mouse_entered() -> void:
	if not item_def or _item_info.visible:
		return
	_item_info.item_def = item_def
	_item_info.global_position = _get_item_info_position()
	_item_info.show()


func _on_mouse_exited() -> void:
	_item_info.hide()
