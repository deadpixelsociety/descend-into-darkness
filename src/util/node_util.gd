class_name NodeUtil


static func clear_children(node: Node):
	var child_count = node.get_child_count()
	if child_count == 0:
		return
	for i in range(child_count - 1, -1, -1):
		var child = node.get_child(i)
		if not child:
			continue
		node.remove_child(child)
		child.queue_free()
