class_name ShaderUtil


static func set_shader_param(sprite: CanvasItem, param: String, value):
	if not sprite:
		return
	var material = sprite.material as ShaderMaterial
	material.set_shader_parameter(param, value)
