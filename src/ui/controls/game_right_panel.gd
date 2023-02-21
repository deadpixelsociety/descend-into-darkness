extends VBoxContainer
class_name GameRightPanel

@export var fixed_size: Vector2

func _ready():
	pass
	#get_tree().root.size_changed.connect(_on_root_size_changed)
	#_update_control_size()


func _update_control_size():
	var video_mode = DisplayServer.window_get_size()
	var y = float(video_mode.y) / fixed_size.y
	var control_scale = int(max(floor(y), 1.0))
	custom_minimum_size = fixed_size * control_scale
	size = custom_minimum_size
	update_minimum_size()


func _on_root_size_changed():
	_update_control_size()
