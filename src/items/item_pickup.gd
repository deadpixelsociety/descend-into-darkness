extends RigidBody2D
class_name ItemPickup

const SEPARATION_DISTANCE = 64.0
const INFO_MARGIN = 16.0

@export var item_def: ItemDefinition:
	set(value):
		item_def = value
		_setup_pickup()

var _picked_up: bool = false
var _spawning: bool = false

@onready var _item_info: ItemInfoControl = $ItemInfoControl
@onready var _rarity_sparkle: GPUParticles2D = $Sprite2D/RaritySparkle
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


func _setup_pickup():
	if not item_def:
		return
	if _sprite:
		_sprite.texture = item_def.item_base.icon
		ShaderUtil.set_shader_param(_sprite, "color", item_def.rarity.color * 1.5)
	_setup_rarity_emitter(_rarity_sparkle)
	_setup_rarity_emitter(_rarity_beam)


func _setup_rarity_emitter(emitter: GPUParticles2D):
	if emitter:
		emitter.emitting = item_def.rarity.particles_enabled
		var mat = emitter.process_material as ParticleProcessMaterial
		mat.color = item_def.rarity.color
		mat.scale_min = item_def.rarity.particle_scale
		mat.scale_max = item_def.rarity.particle_scale


func _on_body_entered(body: Node2D) -> void:
	if _picked_up: 
		return
	if body.has_method("pickup"):
		_picked_up = true
		body.pickup(item_def)
		queue_free()


func _on_mouse_entered() -> void:
	_item_info.item_def = item_def
	_item_info.update_minimum_size()
	_item_info.global_position = _get_item_info_position()
	print(_item_info._item_description.text)
	_item_info.show()


func _get_item_info_position() -> Vector2:
	var info_size = _item_info.get_combined_minimum_size()
	var item_pos = global_position
	var offset = Vector2(INFO_MARGIN, -info_size.y * 0.5)
	item_pos += offset
	var info_rect = Rect2(item_pos, info_size)
	
	var camera = get_viewport().get_camera_2d()
	var viewport_rect = get_viewport_rect() 
	viewport_rect.size *= Vector2.ONE / camera.zoom
	var camera_bounds = Rect2(-viewport_rect.size * 0.5, viewport_rect.size)
	camera_bounds.position -= camera.get_screen_center_position()
	
	if info_rect.end.x > camera_bounds.end.x:
		info_rect.position.x = item_pos.x - info_rect.size.x - (offset.x * 2.0)
	if info_rect.position.y < camera_bounds.position.y:
		info_rect.position.y = camera_bounds.position.y + INFO_MARGIN
	if info_rect.end.y > camera_bounds.end.y:
		info_rect.position.y = camera_bounds.end.y - info_size.y - INFO_MARGIN
	
	return info_rect.position


func _on_mouse_exited() -> void:
	_item_info.hide()


func _on_input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	pass
#	if event is InputEventMouseMotion and _item_info.visible:
#		var info_size = _item_info.get_combined_minimum_size()
#		var mouse_pos = get_global_mouse_position()
#		var offset = Vector2(INFO_MARGIN, -info_size.y * 0.5)
#		mouse_pos += offset
#		var info_rect = Rect2(mouse_pos, info_size)
#
#		var camera = viewport.get_camera_2d()
#		var viewport_rect = get_viewport_rect() 
#		viewport_rect.size *= Vector2.ONE / camera.zoom
#		var camera_bounds = Rect2(-viewport_rect.size * 0.5, viewport_rect.size)
#		camera_bounds.position -= camera.get_screen_center_position()
#		
#		if info_rect.end.x > camera_bounds.end.x:
#			info_rect.position.x = mouse_pos.x - info_rect.size.x - (offset.x * 2.0)
#		if info_rect.position.y < camera_bounds.position.y:
#			info_rect.position.y = camera_bounds.position.y + INFO_MARGIN
#		if info_rect.end.y > camera_bounds.end.y:
#			info_rect.position.y = camera_bounds.end.y - info_size.y - INFO_MARGIN
#		
#		_item_info.global_position = info_rect.position
