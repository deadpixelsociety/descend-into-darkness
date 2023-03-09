extends Node2D
class_name SparkleExplosion

@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	_start()


func _start():
	_animated_sprite.play()
	await _animated_sprite.animation_finished
	queue_free()
