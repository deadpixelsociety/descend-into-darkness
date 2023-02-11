extends Node


func find_nearest_group_member(from: Vector2, group: String) -> Node2D:
	var list = get_tree().get_nodes_in_group(group)
	if list.size() == 0:
		return null
	var min_dist2 = 999999.0
	var min_member: Node2D = null
	for item in list:
		var dist2 = (item.position - from).length_squared()
		if dist2 < min_dist2:
			min_dist2 = dist2
			min_member = item
	return min_member
