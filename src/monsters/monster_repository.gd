extends RefCounted
class_name MonsterRepository

var _monster_types: Array[MonsterType] = []
var _monster_level_map: Dictionary = {}


func _init():
	_load_monster_types("res://src/monsters")


func generate_monsters(count: int, party_level: int) -> Array[MonsterType]:
	var list: Array[MonsterType] = []
	var canidates: Array[MonsterType] = []
	for monster_level in _monster_level_map.keys():
		if monster_level <= party_level:
			var type_list = Collections.get_dict_array(_monster_level_map, monster_level)
			for type in type_list:
				canidates.append(type as MonsterType)
	for i in count:
		list.append(canidates[randi() % canidates.size()])
	return list


func _load_monster_types(path: String):
	var dir = DirAccess.open(path)
	if not dir:
		return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			if file_name.ends_with("tres"):
				var type: MonsterType = load(path + "/" + file_name)
				if type:
					var type_list = Collections.get_dict_array(_monster_level_map, type.monster_level)
					type_list.append(type)
					_monster_types.append(type)
		else:
			_load_monster_types(path + "/" + file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
