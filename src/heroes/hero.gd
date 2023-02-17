extends CharacterBody2D
class_name Hero

var id: String = Guid.generate()
var hero_class: HeroClass:
	set(value):
		hero_class = value
		_setup_hero_class()

var can_attack: bool = true

var _controller: HeroController = null
var _modifiers: Array[Modifier] = []
var _passives: Dictionary = {}
var _stat_modifiers: Dictionary = {}
var _on_hit_modifiers: Array[OnHitModifier] = []
var _health_current: float = 0.0
var _health_max: float = 0.0

@onready var _attack_container: Node2D = $AttackContainer
@onready var _attack_timer: Timer = $AttackTimer
@onready var _blood_splatter: GPUParticles2D = $BloodSplatter
@onready var _effect_container: Node2D = $EffectContainer
@onready var _passive_container: Node2D = $PassiveContainer
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _stats: Stats = $Stats
@onready var _hurtbox: Area2D = $Hurtbox


func _ready():
	EventBus.ui_ready.connect(_on_ui_ready)
	_setup_hero_class()
	if Party.get_leader() == self:
		_controller = InputHeroController.new(self)
	else:
		_controller = FollowerHeroControlller.new(self)
	_set_hero_defaults()


func _physics_process(delta: float):
	if _controller:
		_controller.process(delta)


func get_hurtbox() -> Area2D:
	return _hurtbox


func get_stats() -> Stats:
	return _stats


func apply_modifier(modifier: Modifier):
	_modifiers.append(modifier)
	if modifier is StatModifier:
		_store_stat_modifier(modifier)
		modifier.calculate()
	if modifier is OnHitModifier:
		_on_hit_modifiers.append(modifier)
	_recalculate_stats()


func remove_modifiers(owner_id: String):
	for i in range(_modifiers.size() - 1, -1, -1):
		var modifier = _modifiers[i] as Modifier
		if modifier.ownder_id == owner_id:
			_modifiers.remove_at(i)
			if modifier is StatModifier:
				_remove_stat_modifier(modifier)
			if modifier is OnHitModifier:
				_on_hit_modifiers.erase(modifier)
	_recalculate_stats()


func get_on_hit_modifiers() -> Array[OnHitModifier]:
	return _on_hit_modifiers


func apply_passive(passive: Passive):
	if _passives.has(passive.id):
		return
	_passives[passive.id] = passive
	for modifier in passive.modifiers:
		modifier.ownder_id = passive.id
		apply_modifier(modifier)
	if _passive_container and passive.applied_passive:
		var applied_passive = passive.applied_passive.instantiate() as AppliedPassive
		applied_passive.owner_id = passive.id
		_passive_container.call_deferred("add_child", applied_passive)


func unapply_passive(passive: Passive):
	_passives.erase(passive.id)
	remove_modifiers(passive.id)
	if _passive_container:
		for child in _passive_container.get_children():
			var applied_passive = child as AppliedPassive
			if applied_passive and applied_passive.owner_id == passive.id:
				applied_passive.unapplied()
				applied_passive.queue_free()


func apply_hit(damage: float, hit_type: AttackConstants.HitType):
	# TODO: Take damage
	var effect = Effect.create_hit(hit_type)
	_effect_container.call_deferred("add_child", effect)
	if not _blood_splatter.emitting:
		_blood_splatter.restart()
		_blood_splatter.emitting = true
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
	_take_damage(1.0)


func pickup(item_def: ItemDefinition) -> bool:
	if not Party.is_leader(self):
		return false
	var callback = {}
	EventBus.item_picked_up.emit(item_def, callback)
	return callback.has("success") and callback["success"] == true


func _take_damage(damage: float):
	_health_current = clampf(_health_current - damage, 0.0, _health_max)
	if _health_current <= 0.0:
		# TOOD: Death
		pass
	_on_health_changed()


func _whiteout(amount: float):
	ShaderUtil.set_shader_param(_sprite, "amount", amount)


func _set_hero_defaults():
	_calculate_health()


func _store_stat_modifier(modifier: StatModifier):
	if not _stat_modifiers.has(modifier.stat_type):
		_stat_modifiers[modifier.stat_type] = Array()
	var list = _stat_modifiers[modifier.stat_type] as Array
	list.append(modifier)
	_stat_modifiers[modifier.stat_type] = list


func _remove_stat_modifier(modifier: StatModifier):
	if not _stat_modifiers.has(modifier.stat_type):
		return
	var list = _stat_modifiers[modifier.stat_type] as Array
	list.erase(modifier)
	_stat_modifiers[modifier.stat_type] = list


func _setup_hero_class():
	if not hero_class:
		return
	if _sprite:
		_sprite.frames = hero_class.sprite_frames
		_sprite.frame = randi() % hero_class.sprite_frames.get_frame_count("default")
		_sprite.play()
	_modifiers.clear()
	_stat_modifiers.clear()
	_on_hit_modifiers.clear()
	_passives.clear()
	if hero_class.attack:
		for modifier in hero_class.attack.modifiers:
			modifier.ownder_id = hero_class.id
			apply_modifier(modifier)
	for modifier in hero_class.modifiers:
		modifier.ownder_id = hero_class.id
		apply_modifier(modifier)
	if hero_class.passive:
		apply_passive(hero_class.passive)


func _calculate_health():
	var stats = get_stats()
	if not stats:
		return
	var is_full = _health_current == _health_max
	_health_max = stats.health_max
	if is_full:
		_health_current = _health_max
	_on_health_changed()


func _on_health_changed():
	EventBus.hero_health_changed.emit(self, _health_max, _health_current)


func _recalculate_stats():
	if _stats:
		_stats.calculate(_stat_modifiers)
	_calculate_health()
	_update_attack_timer()


func _update_attack_timer():
	if not _stats:
		return
	if _stats.attack_speed == 0.0:
		_attack_timer.wait_time = 1.0
	else:
		_attack_timer.wait_time = 1.0 / max(0.1, _stats.attack_speed)


func _on_attack_timer_timeout():
	if not can_attack or not hero_class.attack or not hero_class.attack.applied_attack:
		return
	var applied_attack = hero_class.attack.applied_attack.instantiate() as AppliedAttack
	if not applied_attack or not applied_attack.can_attack(self):
		return
	applied_attack.attack_owner = self
	applied_attack.attack(self)
	_attack_container.call_deferred("add_child", applied_attack)


func _on_ui_ready():
	_on_health_changed()
