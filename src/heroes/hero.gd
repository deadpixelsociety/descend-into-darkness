extends CharacterBase
class_name Hero

const MAX_HEALTH: float = 999.0
const MAX_MANA: float = 99.0

var hero_class: HeroClass:
	set(value):
		hero_class = value
		_setup_hero_class()

var can_attack: bool = true

var _controller: HeroController = null
var _passives: Dictionary = {}
var _health_current: float = 0.0
var _health_max: float = 0.0
var _mana_current: float = 0.0
var _mana_max: float = 0.0
var _equipment: Dictionary = {}
var _last_attack_main: bool = false

@onready var _attack_container: Node2D = $AttackContainer
@onready var _attack_timer: Timer = $AttackTimer
@onready var _blood_splatter: GPUParticles2D = $BloodSplatter
@onready var _passive_container: Node2D = $PassiveContainer
@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _hurtbox: Area2D = $HeroHurtbox


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


func get_attack_time() -> float:
	if get_stats().attack_speed == 0.0:
		return 1.0
	else:
		return 1.0 / max(0.1, get_stats().attack_speed)


func equip_item(slot: ItemConstants.EquipmentType, item_def: ItemDefinition):
	if _equipment.has(slot):
		var prev_item = _equipment[slot] as ItemDefinition
		if prev_item:
			unequip_item(slot, prev_item)
	_equipment[slot] = item_def
	for modifier in item_def.modifiers:
		apply_modifier(modifier, false, false)
	_recalculate_stats()
	Party.hero_equipment_changed.emit(self)


func unequip_item(slot: ItemConstants.EquipmentType, item_def: ItemDefinition):
	if item_def:
		remove_modifiers(item_def.id)
	_equipment[slot] = null
	Party.hero_equipment_changed.emit(self)


func get_equipped_item(slot: ItemConstants.EquipmentType) -> ItemDefinition:
	if _equipment.has(slot):
		return _equipment[slot]
	return null


func get_valid_slots(item_def: ItemDefinition) -> Array[ItemConstants.EquipmentType]:
	var list: Array[ItemConstants.EquipmentType] = []
	list.append(ItemConstants.get_equipment_type(item_def.item_type))
	if ItemConstants.WEAPON_TYPES.has(item_def.item_type):
		var weapon_base = item_def.item_base as WeaponBase
		if weapon_base and not weapon_base.two_handed:
			if hero_class.can_dual_wield:
				list.append(ItemConstants.EquipmentType.OFFHAND)
	return list


func can_equip_item(item_def: ItemDefinition) -> bool:
	if ItemConstants.WEAPON_TYPES.has(item_def.item_type):
		if hero_class.weapon_type & item_def.item_type != item_def.item_type:
			return false
		var weapon_base = item_def.item_base as WeaponBase
		if weapon_base:
			if weapon_base.two_handed:
				var offhand = get_equipped_item(ItemConstants.EquipmentType.OFFHAND)
				if offhand != null:
					return false
	if ItemConstants.OFFHAND_TYPES.has(item_def.item_type):
		var weapon = get_equipped_item(ItemConstants.EquipmentType.WEAPON)
		if weapon:
			var weapon_base = weapon.item_base as WeaponBase
			if weapon_base and weapon_base.two_handed:
				return false
	return true


func get_equipment() -> Dictionary:
	return _equipment


func get_weapon() -> ItemDefinition:
	# Do we have an offhand weapon? If so, did we last attack with our main? 
	# If so, return the offhand and switch for next time.
	var offhand = get_equipped_item(ItemConstants.EquipmentType.OFFHAND)
	if offhand \
		and ItemConstants.WEAPON_TYPES.has(offhand.item_type) \
		and _last_attack_main:
		_last_attack_main = false
		return offhand
	var weapon = get_equipped_item(ItemConstants.EquipmentType.WEAPON)
	if not weapon:
		return null
	_last_attack_main = true
	return weapon 


func apply_passive(passive: Passive):
	if _passives.has(passive.id):
		return
	_passives[passive.id] = passive
	for modifier in passive.modifiers:
		modifier.owner_id = passive.id
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


#func apply_hit(damage: float, hit_type: AttackConstants.HitType):
#	# TODO: Take damage
#	var effect = Effect.create_hit(hit_type)
#	_effect_container.call_deferred("add_child", effect)
#	if not _blood_splatter.emitting:
#		_blood_splatter.restart()
#		_blood_splatter.emitting = true
#	var tween = create_tween().bind_node(self)
#	tween.tween_method(
#		_whiteout,
#		0.0,
#		1.0,
#		0.1
#	)
#	tween.tween_method(
#		_whiteout,
#		1.0,
#		0.0,
#		0.1
#	)
#	tween.play()
#	_take_damage(1.0)


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
	_calculate_mana()
	if hero_class.attack and hero_class.attack.persistent:
		_create_attack()
		_attack_timer.autostart = false
		_attack_timer.stop()


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
			modifier.owner_id = hero_class.id
			apply_modifier(modifier)
	for modifier in hero_class.modifiers:
		modifier.owner_id = hero_class.id
		apply_modifier(modifier)
	if hero_class.passive:
		apply_passive(hero_class.passive)
	if hero_class.equipment != null:
		for item_base in hero_class.equipment:
			var item_def = ItemGenerator.generate_base_item(1, item_base)
			if item_def:
				var slot = ItemConstants.get_equipment_type(item_def.item_type)
				equip_item(slot, item_def)


func _calculate_health():
	var stats = get_stats()
	if not stats:
		return
	var is_full = _health_current == _health_max
	_health_max = clampf(stats.health_max, 0.0, MAX_HEALTH)
	if is_full:
		_health_current = _health_max
	_on_health_changed()


func _on_health_changed():
	Party.hero_health_changed.emit(self, _health_max, _health_current)


func _calculate_mana():
	var stats = get_stats()
	if not stats:
		return
	var is_full = _mana_current == _mana_max
	_mana_max = clampf(stats.mana_max, 0.0, MAX_MANA)
	if is_full:
		_mana_current = _mana_max
	_on_mana_changed()


func _on_mana_changed():
	Party.hero_mana_changed.emit(self, _mana_max, _mana_current)


func _update_attack():
	if not get_stats():
		return
	_attack_timer.wait_time = get_attack_time()


func _on_attack_timer_timeout():
	if not can_attack or not hero_class.attack or not hero_class.attack.applied_attack:
		return
	_create_attack()


func _create_attack():
	var applied_attack = hero_class.attack.applied_attack.instantiate() as AppliedAttack
	if not applied_attack:
		return
	applied_attack.setup_attack(self, hero_class.attack, get_weapon())
	if not applied_attack.can_attack():
		return
	_attack_container.add_child(applied_attack)
	applied_attack.configure_attack()
	applied_attack.attack()


func _on_ui_ready():
	_on_health_changed()
	_on_mana_changed()
