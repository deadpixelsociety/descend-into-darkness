extends AppliedAttack
class_name AxeToss

@export var projectile_speed = 200.0
@export var rotation_speed = 360.0

var _slashing: bool = false
var _velocity: Vector2 = Vector2.ZERO

@onready var _after_image_spawner: AfterImageSpawner = $AfterImageSpawner
@onready var _axe: Sprite2D = $Axe
@onready var _hitbox: Hitbox = $Axe/HeroHitbox


func _ready():
	_hitbox.hitbox_owner = get_hero()


func _physics_process(delta: float):
	if not _slashing:
		global_position += _velocity * delta
		_axe.rotate(deg_to_rad(rotation_speed) * delta)


func configure_attack():
	super.configure_attack()
	var weapon = get_weapon()
	if not weapon:
		return
	var weapon_base = weapon.item_base as WeaponBase
	if weapon_base and weapon_base.projectile_texture:
		_axe.texture = weapon_base.projectile_texture


func can_attack() -> bool:
	var hero = get_hero()
	if not hero:
		return false
	var nearest = GameUtil.find_nearest_group_member(hero.position, Groups.MONSTER) as Monster
	if not nearest or nearest.is_spawning():
		return false
	set_target(nearest.position)
	return true


func attack():
	var hero = get_hero()
	if not hero:
		return
	set_offset_position()
	var dir = hero.global_position.direction_to(get_target())
	_velocity = dir * projectile_speed
	_after_image_spawner.start_spawning()


func _slash(monster_hit: bool):
	_slashing = true
	var color = Color.from_string("D01716", Color.RED)
	if not monster_hit:
		color = Color.WHITE
	GlobalEffects.slashes(global_position, color, 2)
	queue_free()


func _on_hero_hitbox_hitbox_entered(collider):
	_slash(collider is Hurtbox)
