extends Camera2D
class_name PartyCamera


func _physics_process(delta):
	var positions = Vector2.ZERO
	for hero in Party.get_heroes():
		positions += hero.global_position
	positions /= float(Party.get_heroes().size())
	position = positions
