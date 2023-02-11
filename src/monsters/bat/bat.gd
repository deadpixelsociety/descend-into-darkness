extends Monster
class_name Bat

var _attack_start: Vector2 = Vector2.ZERO
var _attack_end: Vector2 = Vector2.ZERO
var _target: Node2D


func _physics_process(delta: float):
	super._physics_process(delta)
	if is_attacking():
		var dir = position.direction_to(_attack_end)
		var distance = position.distance_to(_attack_end)
		if distance >= 1.0:
			velocity = dir * attack_speed
		else:
			velocity = Vector2.ZERO
		move_and_slide()


func can_attack(target: Node2D) -> bool:
	return not is_attacking()


func attack(target: Node2D):
	_target = target
	_attacking = true
	var dist = position.distance_to(target.position)
	var dir = position.direction_to(target.position)
	_attack_start = position
	_attack_end = _attack_start + (dir * dist * 2.0)
	collision_mask &= ~2
	_animation_player.play("attack")
	await _animation_player.animation_finished
	collision_mask |= 2
	_attacking = false
	attack_finished.emit()
