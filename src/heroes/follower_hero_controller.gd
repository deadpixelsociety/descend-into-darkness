extends HeroController
class_name FollowerHeroControlller

const FOLLOW_DISTANCE = 32.0


func process(delta: float):
	var heroes = Party.get_heroes()
	var idx = heroes.find(_hero)
	if idx - 1 < 0:
		return
	var to_follow = heroes[idx - 1]
	var dir = _hero.global_position.direction_to(to_follow.global_position)
	var target = to_follow.global_position - (dir * FOLLOW_DISTANCE)
	var distance = _hero.global_position.distance_to(target)
	if distance > FOLLOW_DISTANCE:
		_hero.velocity = dir * Party.get_average_movement_speed()
		_hero.move_and_slide()
