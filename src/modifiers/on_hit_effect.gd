extends Node2D
class_name OnHitEffect

var _modifier: OnHitModifier
var _applicator: Node2D
var _target: Node2D
var _duration: float = 0.0
var _duration_timer: float = 0.0
var _expired: bool = false


func _process(delta: float):
	if _duration > 0.0:
		_duration_timer += delta
		if not is_expired():
			_effect_tick(delta)
		if _duration_timer >= _duration:
			_expired = true
			await _effect_end()
			queue_free()


func apply_effect(modifier: OnHitModifier, applicator: Node2D, target: Node2D):
	_modifier = modifier
	_applicator = applicator
	_target = target
	_duration = modifier.on_hit_duration
	# For refresh types check if we already have the same type on the target 
	# and attempt to refresh it. If successful, remove this instance.
	if modifier.on_hit_application == OnHitModifier.OnHitApplication.REFRESH:
		if _apply_refresh(target, modifier):
			queue_free()
			return
	_effect_start()


func is_expired() -> bool:
	return _expired


func get_on_hit_type() -> OnHitModifier.OnHitType:
	return _modifier.on_hit_tyoe


func refresh_effect(modifier: OnHitModifier):
	_expired = false
	if modifier.on_hit_duration > _duration:
		_duration = modifier.on_hit_duration


func _apply_refresh(target: Node2D, modifier: OnHitModifier):
	var effects = GameUtil.get_effects_of_type(target, modifier.on_hit_tyoe)
	if effects.size() == 0:
		return false
	var effect = effects.front() as OnHitEffect
	effect.refresh_effect(modifier)
	return true


func _effect_start():
	pass


func _effect_end():
	pass


func _effect_tick(delta: float):
	pass
