extends Node2D
class_name AfterImageSpawner

@export var target: Node2D
@export var spawn_time: float = 0.0
@export var image_duration: float = 1.0
@export var gradient: Gradient
@export var scale_curve: Curve

var AFTER_IMAGE: PackedScene = load("res://src/fx/after_image.tscn")

var _spawn_timer: float = 0.0
var _spawning: bool = false


func _process(delta: float):
	if _spawning:
		_spawn_timer += delta
		if _spawn_timer >= spawn_time:
			_spawn_timer -= spawn_time
			_spawn()


func start_spawning():
	_spawn_timer = 0.0
	_spawn()
	_spawning = true


func end_spawning():
	_spawning = false


func _spawn():
	var after_image = AFTER_IMAGE.instantiate() as AfterImage
	after_image.duration = image_duration
	after_image.gradient = gradient
	after_image.scale_curve = scale_curve
	if target is Sprite2D:
		after_image.spawn_sprite(target)
	elif target is AnimatedSprite2D:
		after_image.spawn_animated_sprite(target)
	add_child(after_image)
