extends Node
class_name Main


func _ready():
	get_tree().root.size_changed.connect(_on_size_changed)
	_scale_game()


func _scale_game():
	var base_width = ProjectSettings.get("display/window/size/viewport_width")
	var base_height = ProjectSettings.get("display/window/size/viewport_height")
	var window_size = DisplayServer.window_get_size()
	var factor = int(max(floor(float(window_size.y) / float(base_height)), 1.0))
	var window = get_window()
	window.content_scale_size = Vector2i(base_width, base_height)
	window.content_scale_factor = factor


func _on_size_changed():
	_scale_game()
