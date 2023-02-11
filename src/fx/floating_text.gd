extends Node2D
class_name FloatingText

const GRAVITY = Vector2(0.0, 98.0)

@export var text: String = "":
	set(value):
		text = value
		_setup_label()

@export var color: Color = Color.RED:
	set(value):
		color = value
		_setup_label()

@export var outline: bool = true:
	set(value):
		outline = value
		_setup_label()

@export var outline_color: Color = Color.WHITE:
	set(value):
		outline_color = value
		_setup_label()
		
@export var outline_size: float = 4.0:
	set(value):
		outline_size = value
		_setup_label()

@export var scale_factor: float = 1.0

@export var duration: float = 1.0

var _velocity: Vector2 = Vector2.ZERO

@onready var _label: Label = $Label


func _ready():
	_setup_label()


func _physics_process(delta: float):
	_velocity += GRAVITY * delta
	global_position += _velocity * delta


func spawn(spawn_point: Vector2):
	global_position = spawn_point
	_velocity = (Vector2.UP.rotated(deg_to_rad(randf_range(-15.0, 15.0)))) * 150.0
	modulate.a = 1.0
	var tween = create_tween().bind_node(self)
	tween.set_ease(Tween.EASE_OUT).tween_property(
		self,
		"modulate:a",
		0.0,
		duration
	)
	tween.parallel().tween_property(
		self,
		"scale",
		Vector2(1.0, 1.0) * scale_factor,
		duration
	)
	tween.play()
	await tween.finished
	queue_free()


func _setup_label():
	if not _label:
		return
	_label.text = text
	_label.label_settings.font_color = color
	_label.label_settings.outline_size = 0.0 if not outline else outline_size
	_label.label_settings.outline_color = outline_color
