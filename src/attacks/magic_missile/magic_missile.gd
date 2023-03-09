extends AppliedAttack
class_name MagicMissile

@export var missile_speed: float = 300.0
@export var missile_spread: float = 60.0

var _exploding: bool = false

@onready var _hitbox: Hitbox = $Missile/HeroHitbox
@onready var _missile: Sprite2D = $Missile


func _ready():
	_hitbox.hitbox_owner = get_hero()


func _physics_process(delta: float):
	if not _exploding:
		var target_heading = global_position.direction_to(get_target())
		var current_heading = Vector2.RIGHT.rotated(_missile.rotation)
		var change = (target_heading - current_heading) * 0.075
		var new_heading = current_heading + change
		var velocity = Vector2.RIGHT.rotated(new_heading.angle()) * missile_speed
		global_position += velocity * delta
		_missile.look_at(position + velocity)


func can_attack() -> bool:
	var hero = get_hero()
	if not hero:
		return false
	var nearest = GameUtil.find_random_group_member(Groups.MONSTER) as Monster
	if not nearest or nearest.is_spawning():
		return false
	set_target(nearest.global_position)
	return true


func attack():
	var hero = get_hero()
	if not hero:
		return
	set_offset_position()
	_missile.look_at(get_target())
	_missile.rotate(deg_to_rad(randf_range(-missile_spread, missile_spread)))


func _explode():
	_exploding = true
	var color = Color.from_string("91C8D8", Color.WHITE)
	GlobalEffects.sparkle_explosions(global_position, color, 4, 24.0)
	queue_free()


func _on_hero_hit_box_hitbox_entered(is_hurtbox) -> void:
	_explode()


func _on_lifetime_timeout():
	_explode()
