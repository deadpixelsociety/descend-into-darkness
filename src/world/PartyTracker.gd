extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var positions = Vector2.ZERO
	for hero in Party.get_heroes():
		positions += hero.position
	positions /= float(Party.get_heroes().size())
	position = ceil(positions)
