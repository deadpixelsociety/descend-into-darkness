@tool
extends Container
class_name FitContainer


func _get_minimum_size() -> Vector2:
	var ms = Vector2.ZERO
	for i in get_child_count():
		var child = get_child(i) as Control
		if not child:
			continue
		if not child.visible:
			continue
		if child.top_level:
			continue
		var child_ms = child.get_combined_minimum_size()
		ms.x = max(ms.x, child_ms.x)
		ms.y = max(ms.y, child_ms.y)
	return ms


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_SORT_CHILDREN:
			for i in get_child_count():
				var child = get_child(i) as Control
				if not child:
					continue
				if child.top_level:
					continue
				fit_child_in_rect(child, Rect2(Vector2.ZERO, get_combined_minimum_size()))
