extends Node2D

var FLOATING_TEXT: PackedScene = load("res://src/fx/floating_text.tscn")


func spawn_text(
	text_position: Vector2,
	text: String,
	color: Color,
	duration: float = 1.0,
	scale_factor: float = 1.0,
	outline: bool = true,
	outline_color: Color = Color.WHITE,
	outline_size: float = 4.0
):
	var floating_text = FLOATING_TEXT.instantiate() as FloatingText
	floating_text.text = text
	floating_text.color = color
	floating_text.duration = duration
	floating_text.scale_factor = scale_factor
	floating_text.outline = outline
	floating_text.outline_color = outline_color
	floating_text.outline_size = outline_size
	add_child(floating_text)
	floating_text.spawn(text_position)
