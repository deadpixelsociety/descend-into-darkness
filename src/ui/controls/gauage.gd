@tool
extends Control
class_name Gauge

@export var value: float = 0.0:
	set(new_value):
		value = clampf(new_value, 0.0, 1.0)
		_update_gauage()

@onready var _margin_container: MarginContainer = %MarginContainer
@onready var _fill: TextureRect = %Fill
@onready var _fill_edge: TextureRect = %FillEdge


func _ready():
	_update_gauage()


func tween_value(new_value: float, duration: float = 0.5):
	var tween = create_tween().bind_node(self)
	tween.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)\
		.tween_property(
			self,
			"value",
			new_value,
			duration
		)
	tween.play()


func _update_gauage():
	if not is_inside_tree():
		return
	await RenderingServer.frame_post_draw
	var r = _margin_container.get_theme_constant("margin_right")
	var l = _margin_container.get_theme_constant("margin_left")
	var width = _margin_container.size.x - r - l
	var fill_width = clampf((width * value), 0.0, width)
	_fill.size.x = fill_width
	_fill_edge.position.x = r + fill_width - (l if fill_width > 0.0 else 0.0) + 1.0
