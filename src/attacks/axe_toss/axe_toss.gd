extends AppliedAttack
class_name AxeToss

@export var projectile_speed = 200.0
@export var rotation_speed = 360.0

var _velocity: Vector2 = Vector2.ZERO
var _target: Vector2 = Vector2.ZERO


func can_attack(hero: Hero) -> bool:
	var nearest = GameUtil.find_nearest_group_member(hero.position, Groups.MONSTER) as Monster
	if not nearest or nearest.is_spawning():
		return false
	_target = nearest.position
	return true


func attack(hero: Hero):
	var dir = (_target - hero.position).normalized()
	_velocity = (dir * projectile_speed)
	position = hero.position


func _physics_process(delta: float):
	position += _velocity * delta
	rotation += deg_to_rad(rotation_speed * delta)


func _on_hitbox_body_entered(body: Node2D) -> void:
	queue_free()


func _apply_on_hit(monster: Monster):
	if attack_owner is Hero:
		var on_hit_modifiers = attack_owner.get_on_hit_modifiers()
		for modifier in on_hit_modifiers:
			monster.add_effect(attack_owner, modifier)


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is HurtBox:
		var monster = area.hurtbox_owner as Monster
		if monster:
			_apply_on_hit(monster)
		queue_free()
