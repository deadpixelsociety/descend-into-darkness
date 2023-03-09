extends CharacterBase
class_name Monster

signal attack_finished(monster)
signal spawn_started(monster)
signal spawn_finished(monster)

@export var movement_speed: float = 75.0
@export var attack_speed: float = 100.0
@export var attack_animation: float = 0.0:
	set(value):
		attack_animation = min(max(value, 0.0), 1.0)
		if is_attacking():
			_update_attack_animation()

@export var knockback_time: float = 0.1
@export var knockback_speed: float = 150.0

var FLOATING_TEXT: PackedScene = load("res://src/fx/floating_text.tscn")

var _attacking: bool = false
var _knockbar_dir: Vector2 = Vector2.ZERO
var _knockback_timer: float = 0.0
var _spawning: bool = false


@onready var _animation_player: AnimationPlayer = $AnimationPlayer
#@onready var _behavior_tree: BTRoot = $BehaviorTree
@onready var _effect_container: Node2D = $EffectContainer
@onready var _hitbox: Area2D = $MonsterHitbox
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _stats: Stats = $Stats
@onready var _terrain_ray: RayCast2D = $TerrainRay


func _ready():
	spawn_started.connect(_on_spawn_started)
	spawn_finished.connect(_on_spawn_finished)
	
	if _sprite.sprite_frames:
		var frames = _sprite.sprite_frames.get_frame_count("default")
		_sprite.frame = randi() % frames
		_sprite.play()


func _physics_process(delta: float):
	if _knockback_timer > 0.0:
		_knockback_timer -= delta
		if _knockback_timer <= 0.0:
			_knockback_timer = 0.0
		velocity = _knockbar_dir * knockback_speed
	move_and_slide()


func get_hitbox() -> Area2D:
	return _hitbox


func spawn(spawn_point: Vector2):
	_setup_monster()
	spawn_started.emit(self)
	_spawning = true
	modulate.a = 0.0
	position = spawn_point
	var tween = create_tween().bind_node(self)
	tween.tween_property(
		self,
		"modulate:a",
		1.0,
		0.3
	)
	tween.play()
	await tween.finished
	spawn_finished.emit(self)
	_spawning = false


func is_spawning() -> bool:
	return _spawning


func move(dir: Vector2):
	var ray_length = _terrain_ray.target_position.length()
	_terrain_ray.target_position = dir * ray_length
	_terrain_ray.force_raycast_update()
	if _terrain_ray.is_colliding():
		dir *= -1.0
	velocity = dir * movement_speed


func stop():
	velocity = Vector2.ZERO


func knockback(hit_position: Vector2):
	_knockback_timer = knockback_time
	_knockbar_dir = hit_position.direction_to(global_position)


func can_attack(target: Node2D) -> bool:
	return true


func is_attacking() -> bool:
	return _attacking


func attack(target: Node2D):
	_attacking = true
	attack_finished.emit(self)
	_attacking = false


func _setup_monster():
	movement_speed = movement_speed * RandUtil.randfn_range(0.5, 1.0, 0.5, 0.3)
	scale = Vector2.ONE * RandUtil.randfn_range(0.5, 1.75, 0.5, 0.05)


func _on_hurtbox_area_entered(area: Area2D):
	knockback(area.global_position)
	var dmg = int(1 + randf() * 20)
	TextSpawner.spawn_text(
		global_position,
		str(dmg),
		Color.RED,
		2.0,
		clampf(float(dmg) / 7.0, 1.0, 4.0)
	)
	var tween = create_tween().bind_node(self)
	tween.tween_method(
		_whiteout,
		0.0,
		1.0,
		0.1
	)
	tween.tween_method(
		_whiteout,
		1.0,
		0.0,
		0.1
	)
	tween.play()
	await tween.finished
	#queue_free()


func _whiteout(amount: float):
	ShaderUtil.set_shader_param(_sprite, "amount", amount)


func _update_attack_animation():
	pass


func _do_attack_hit():
	pass


func _on_hitbox_area_entered(area: Area2D):
	var target = area.get_parent()
	if not target or not target.has_method("apply_hit"):
		return
	target.apply_hit(0.0, AttackConstants.HitType.CLAW)


func _on_spawn_started(monster: Monster):
	pass
	#_behavior_tree.enabled = false


func _on_spawn_finished(monster: Monster):
	pass
	#_behavior_tree.enabled = true
