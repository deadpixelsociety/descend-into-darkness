@tool
extends PanelContainer
class_name ResourceVialHorizontal

const VIAL_BORDER_WIDTH: float = 3.0

@export var resource_bar_texture: Texture2D:
	set(value):
		resource_bar_texture = value
		_setup_resource()
	
@export_range(0.0, 1.0) var resource_value: float = 1.0:
	set(value):
		resource_value = clampf(value, 0.0, 1.0)
		_update_resource_value()

@onready var _resource_bar: NinePatchRect = $ResourceBar


func _ready():
	_setup_resource()
	_update_resource_value()


func tween_resource_value(value: float, duration: float = 0.1):
	var tween = create_tween().bind_node(self)
	tween.tween_property(
		self, 
		"resource_value",
		value,
		duration
	)
	tween.play()


func _setup_resource():
	if _resource_bar:
		_resource_bar.texture = resource_bar_texture


func _update_resource_value():
	if not _resource_bar:
		return
	_resource_bar.visible = resource_value > 0.0
	if resource_value > 0.0:
		var resource_height = size.y - (VIAL_BORDER_WIDTH * 2.0)
		var resource_max_width = size.x - (VIAL_BORDER_WIDTH * 2.0)
		var resource_width = resource_max_width * resource_value
		_resource_bar.custom_minimum_size.x = floor(resource_width)
		_resource_bar.custom_minimum_size.y = floor(resource_height)
