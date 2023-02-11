extends HeroController
class_name InputHeroController


func process(delta: float):
	var x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var dir = Vector2(x, y).normalized()
	var movement_speed = Party.get_average_movement_speed()
	_hero.velocity = dir * movement_speed
	_hero.move_and_slide()
