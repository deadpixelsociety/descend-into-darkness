extends SubViewportContainer
class_name WorldRenderContainer

@export var darkness_level: float = 0.1:
	set(value):
		darkness_level = value
		_setup_darkness()

var _light_positions: PackedVector2Array = PackedVector2Array()
var _light_colors: PackedColorArray = PackedColorArray()
var _light_radii: PackedFloat32Array = PackedFloat32Array()


func _ready():
	_setup_darkness()


func _process(delta: float):
	_light_positions.clear()
	_light_colors.clear()
	_light_radii.clear()
	var light_sources = get_tree().get_nodes_in_group("light_source")
	light_sources.reverse()
	for node in light_sources:
		var light_source = node as LightSource
		if not light_source.light_enabled:
			continue
		_light_positions.append(light_source.global_position)
		_light_colors.append(light_source.light_color)
		_light_radii.append(light_source.light_radius)
	ShaderUtil.set_shader_param(self, "light_count", _light_positions.size())
	ShaderUtil.set_shader_param(self, "light_positions", _light_positions)
	ShaderUtil.set_shader_param(self, "light_colors", _light_colors)
	ShaderUtil.set_shader_param(self, "light_radii", _light_radii)

func _setup_darkness():
	modulate.a = darkness_level
