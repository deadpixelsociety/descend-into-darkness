extends Node2D
class_name SpawnEffect

signal spawn_finished()

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _pentagram: Sprite2D = $Pentagram


func _ready():
	_pentagram.rotation_degrees = randf() * 360.0
	modulate.a = 0.0
	scale = Vector2(4.0, 4.0)
	var tween = create_tween().bind_node(self)
	tween.tween_property(
		self,
		"modulate:a",
		1.0,
		0.3
	)
	tween.parallel().tween_property(
		self,
		"scale",
		Vector2.ONE,
		0.3
	)
	tween.play()
	await tween.finished
	_animated_sprite.play("spawn")
	await _animated_sprite.animation_finished
	spawn_finished.emit()
	tween = create_tween().bind_node(self)
	tween.tween_property(
		self,
		"modulate:a",
		0.0,
		0.3
	)
	tween.play()
	await tween.finished
	queue_free()


func _process(delta: float):
	_pentagram.rotate(deg_to_rad(90.0) * delta)
