extends Sprite2D
class_name AfterImage

@export var duration: float = 1.0
@export var gradient: Gradient
@export var scale_curve: Curve

var _timer = 0.0


func _ready():
	top_level = true
	_timer = duration


func _process(delta: float):
	if _timer <= 0.0:
		_timer = 0.0
		queue_free()
	if _timer > 0.0:
		var factor = clampf(_timer / duration, 0.0, 1.0)
		if gradient:
			modulate = gradient.sample(factor)
		if scale_curve:
			scale = Vector2.ONE * scale_curve.sample_baked(factor)
		_timer -= delta


func spawn(other: Sprite2D):
	texture = other.texture
	hframes = other.hframes
	vframes = other.vframes
	frame = other.frame
	flip_h = other.flip_h
	global_scale = other.global_scale
	global_rotation = other.global_rotation
	global_position = other.global_position
	top_level = other.top_level
