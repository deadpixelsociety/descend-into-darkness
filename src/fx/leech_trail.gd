extends Sprite2D
class_name LeechTrail

@export var trail_delay: float = 1.0
@export var trail_speed: float = 200.0
@export var lifetime: float = 5.0

var AFTER_IMAGE: PackedScene = load("res://src/fx/after_image.tscn")
var _lifetime_timer: float = 0.0
var _trail_timer: float = 0.0
var _target: Node2D


func spawn(target: Node2D, start: Vector2):
	_lifetime_timer = lifetime
	_trail_timer = trail_delay
	_target = target
	global_position = start


func _physics_process(delta: float):
	_trail_timer -= delta
	if _trail_timer <= 0.0:
		_trail_timer = trail_delay
		_spawn_after_image()
	_lifetime_timer -= delta
	if not _target or _lifetime_timer <= 0.0:
		queue_free()
	else:
		var d = Time.get_ticks_msec() / 250.0
		scale = Vector2.ONE * (1.0 + abs(sin(d)) * 0.8)
		var dist = global_position.distance_to(_target.global_position)
		if dist <= 8.0:
			queue_free()
		else:
			var dir = global_position.direction_to(_target.global_position)
			var velocity = dir * trail_speed
			global_position += velocity * delta


func _spawn_after_image():
	var after_image = AFTER_IMAGE.instantiate() as AfterImage
	after_image.duration = 0.3
	after_image.gradient = load("res://assets/gradients/leech.tres")
	after_image.scale_curve = load("res://assets/curves/leech.tres")
	GlobalEffects.add_effect(after_image)
	after_image.spawn(self)
