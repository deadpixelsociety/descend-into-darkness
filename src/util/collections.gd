class_name Collections


static func get_dict_array(dict: Dictionary, key) -> Array:
	var list: Array
	if dict.has(key):
		list = dict[key]
	else:
		list = []
	dict[key] = list
	return list


static func get_dict_dict(dict: Dictionary, key) -> Dictionary:
	var dict2: Dictionary
	if dict.has(key):
		dict2 = dict[key]
	else:
		dict2 = {}
	dict[key] = dict2
	return dict2


static func get_random_enum_value(dict: Dictionary) -> int:
	var size = dict.size()
	var keys = dict.keys()
	return keys[randi() % size]
