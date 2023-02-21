extends Camera2D
class_name PartyCamera

var _real_position: Vector2


func _ready():
	_real_position = position


func _physics_process(delta):
	var positions = Vector2.ZERO
	for hero in Party.get_heroes():
		positions += hero.position
	positions /= float(Party.get_heroes().size())
	_real_position = lerp(_real_position, positions, 0.1)
	position = floor(_real_position)
