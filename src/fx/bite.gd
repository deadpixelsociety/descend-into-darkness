extends Node2D
class_name Bite

@export var fangs_offset: float = 32.0

var _target: Node2D

@onready var _fangs: Sprite2D = $Fangs


func _physics_process(delta: float):
	if _target and is_instance_valid(_target):
		global_position = _target.global_position


func spawn(target: Node2D):
	_target = target
	global_position = target.global_position
	var angle = deg_to_rad(randf_range(-45.0, 45.0))
	var dir = Vector2.UP.rotated(angle)
	_fangs.position = dir * fangs_offset
	_fangs.rotation = angle
	_fangs.scale = Vector2.ZERO
	var tween = create_tween().bind_node(self)
	tween.set_ease(Tween.EASE_IN).tween_property(
		_fangs,
		"scale",
		Vector2(0.8, 0.8),
		0.3
	)
	tween.parallel().tween_property(
		_fangs,
		"position",
		Vector2.ZERO,
		0.4
	)
	tween.parallel().tween_method(
		_update_rotation,
		angle,
		0.0,
		0.4
	)
	tween.tween_property(
		_fangs,
		"modulate:a",
		0.0,
		0.2
	)
	tween.play()
	await tween.finished
	queue_free()


func _update_rotation(value: float):
	_fangs.rotation = wrapf(value, -PI, PI)
