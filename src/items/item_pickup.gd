extends RigidBody2D
class_name ItemPickup

const SEPARATION_DISTANCE = 64.0

@export var item_def: ItemDefinition:
	set(value):
		item_def = value
		_setup_pickup()

var _can_pick_up: bool = true
var _picked_up: bool = false
var _spawning: bool = false

@onready var _light_source: LightSource = $LightSource
@onready var _rarity_beam: GPUParticles2D = $Sprite2D/RarityBeam
@onready var _sprite: Sprite2D = $Sprite2D


func _ready():
	_setup_pickup()
	spawn()


func spawn():
	_spawning = true
	modulate.a = 0.0
	var tween = create_tween().bind_node(self)
	tween.tween_property(
		self,
		"modulate:a",
		1.0,
		0.25
	)
	tween.play()
	await tween.finished
	_spawning = false


func is_spawning() -> bool:
	return _spawning


func can_pick_up() -> bool:
	return _can_pick_up


func drop():
	_picked_up = false
	linear_velocity = RandUtil.rand_dir() * 50.0
	_can_pick_up = false
	var tween = create_tween().bind_node(self).tween_interval(1.0)
	await tween.finished
	_can_pick_up = true


func _setup_pickup():
	if not item_def:
		return
	if _sprite:
		_sprite.texture = item_def.item_base.icon
	_setup_light_source()
	_setup_rarity_emitter(_rarity_beam)


func _pickup(node: Node2D):
	if node.has_method("pickup"):
		var success = node.pickup(item_def)
		if success:
			linear_velocity = Vector2.ZERO
			_picked_up = true
			var tween = create_tween().bind_node(self)
			tween.tween_property(
				_sprite,
				"modulate:a",
				0.0,
				0.2
			)
			tween.play()
			await tween.finished
			queue_free()


func _setup_light_source():
	if not _light_source:
		return
	_light_source.light_enabled = item_def.rarity.particles_enabled
	_light_source.light_color = item_def.rarity.color


func _setup_rarity_emitter(emitter: GPUParticles2D):
	if emitter:
		emitter.emitting = item_def.rarity.particles_enabled
		var mat = emitter.process_material as ParticleProcessMaterial
		mat.color = item_def.rarity.color
		mat.scale_min = item_def.rarity.particle_scale
		mat.scale_max = item_def.rarity.particle_scale


func _on_body_entered(body: Node2D) -> void:
	if _picked_up or not can_pick_up(): 
		return
	_pickup(body)


func _on_mouse_entered() -> void:
	EventBus.item_hovered.emit(item_def)


func _on_mouse_exited() -> void:
	EventBus.item_unhovered.emit(item_def)
