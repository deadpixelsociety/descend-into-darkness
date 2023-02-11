extends Sprite2D
class_name Darkness

@export var darkness_level: float = 0.1:
	set(value):
		darkness_level = value
		_setup_darkness()


func _ready():
	_setup_darkness()


func _process(delta: float):
	var party_positions: Array[Vector2] = []
	for hero in Party.get_heroes():
		party_positions.append(hero.position)
	ShaderUtil.set_shader_param(self, "party_positions", party_positions)

func _setup_darkness():
	modulate.a = darkness_level
