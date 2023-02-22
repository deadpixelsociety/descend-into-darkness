class_name ItemGenerator

const ITEM_DEFINITION = preload("res://src/items/item_definition.gd")
const ITEM_LEVEL_SPREAD = 7

var _item_bases: Dictionary = {}
var _rarities: Array[Rarity] = []
var _tiers: Array[ModifierTier] = []
# item type > affix > modifier group > tiers
var _tier_map: Dictionary = {} 
var _modifier_icons: Dictionary = {}


func _init():
	_load_tiers()
	_load_rarities("res://src/items/rarity")
	_load_bases("res://src/items/bases")
	_load_modifier_icons()


func generate_item(item_level: int) -> ItemDefinition:
	var type = Collections.get_random_enum_value(ItemConstants.ItemType)
	return generate_item_of_type(item_level, type)


func generate_item_of_set(item_level: int, item_set: Array[ItemConstants.ItemType]) -> ItemDefinition:
	var item_type = item_set[randi() % item_set.size()]
	return generate_item_of_type(item_level, item_type)


func generate_item_of_type(item_level: int, item_type: ItemConstants.ItemType) -> ItemDefinition:
	var def: ItemDefinition = ITEM_DEFINITION.new()
	
	var base_list = Collections.get_dict_array(_item_bases, item_type)
	def.item_base = base_list[randi() % base_list.size()]
	def.item_level = item_level
	def.item_type = item_type
	def.rarity = _generate_rarity()
	def.tiers.append_array(_generate_modifier_tiers(
		item_type,
		def.rarity.total_affixes,
		def.rarity.prefixes_min,
		def.rarity.prefixes_max, 
		def.rarity.suffixes_min,
		def.rarity.suffixes_max, 
		item_level 
	))
	
	def.modifiers.append_array(_get_item_base_modifiers(def.item_base))
	def.modifiers.append_array(_generate_modifiers(def.tiers))
	
	def.item_name = _generate_item_name(item_type, def.item_base, def.tiers)
	def.description_lines = _generate_description(def.tiers)

	return def


func _get_item_base_modifiers(item_base: ItemBase) -> Array[Modifier]:
	var list: Array[Modifier] = []
	for modifier in item_base.modifiers:
		_append_modifier(modifier.duplicate(true), list)
	return list


func _generate_item_name(
	item_type: ItemConstants.ItemType, 
	item_base: ItemBase,
	tiers: Array[ModifierTier]
) -> String:
	if tiers.size() <= 2:
		return _generate_small_item_name(item_type, item_base, tiers)
	return _generate_random_item_name(item_type)


func _generate_small_item_name(
	item_type: ItemConstants.ItemType, 
	item_base: ItemBase,
	tiers: Array[ModifierTier]
) -> String:
	var prefixes: Array[ModifierTier] = []
	var suffixes: Array[ModifierTier] = []
	for tier in tiers:
		if tier.affix_type == ModifierTier.AffixType.PREFIX:
			prefixes.append(tier)
		else:
			suffixes.append(tier)
	var pieces: Array[String] = []
	if prefixes.size() > 0:
		pieces.append(prefixes[randi() % prefixes.size()].tier_name)
	pieces.append(item_base.base_name)
	if suffixes.size() > 0:
		pieces.append(suffixes[randi() % suffixes.size()].tier_name)
	return " ".join(pieces)


func _generate_random_item_name(
	item_type: ItemConstants.ItemType
) -> String:
	var prefix = ItemConstants.ITEM_NAME_PREFIXES[randi() % ItemConstants.ITEM_NAME_PREFIXES.size()]
	var suffixes = ItemConstants.ITEM_NAME_SUFFIXES[item_type]
	var suffix: String = ""

	if suffix == "" and suffixes.size() > 0:
		suffix = suffixes[randi() % suffixes.size()]
	return "%s %s" % [ prefix, suffix ]


func _generate_rarity() -> Rarity:
	var weights: Dictionary = {}
	for rarity in _rarities:
		weights[rarity] = rarity.rate
	return RandUtil.rand_weighted(weights)


func _generate_modifier_tiers(
	item_type: ItemConstants.ItemType,
	total_affixes: int,
	prefixes_min: int, 
	prefixes_max: int, 
	suffixes_min: int, 
	suffixes_max: int, 
	item_level: int
) -> Array[ModifierTier]:
	var list: Array[ModifierTier] = []
	
	if total_affixes == 0:
		return list
	
	# Prefixes
	var prefix_count = randi_range(prefixes_min, prefixes_max)
	if prefix_count != 0:
		_append_affixes(
			list, 
			item_level,
			prefix_count,
			item_type,
			ModifierTier.AffixType.PREFIX
		)
	
	total_affixes -= prefix_count
	if total_affixes > 0:
		var suffix_count = clampi(randi_range(suffixes_min, suffixes_max), suffixes_min, total_affixes)
		if suffix_count != 0:
			_append_affixes(
				list, 
				item_level,
				suffix_count,
				item_type,
				ModifierTier.AffixType.SUFFIX
			)
	
	return list


func _append_affixes(
	list: Array[ModifierTier], 
	item_level: int, 
	affix_count: int, 
	item_type: ItemConstants.ItemType, 
	affix_type: ModifierTier.AffixType
):
	var level_max = item_level
	var level_min = max(1, level_max - ITEM_LEVEL_SPREAD)
	var affixes_map = Collections.get_dict_dict(_tier_map, item_type)
	var group_map = Collections.get_dict_dict(affixes_map, affix_type)
	var groups = group_map.keys()
	if groups.size() != 0:
		while affix_count > 0 and groups.size() > 0:
			var group = groups[randi() % groups.size()]
			groups.erase(group)
			var tiers: Array = Collections.get_dict_array(group_map, group) as Array[ModifierTier]
			var available: Array[ModifierTier] = []
			for tier in tiers:
				if level_max >= tier.item_level_min \
					and tier.item_level_min >= level_min:
					available.append(tier)
			if available.size() == 0:
				continue
			var tier = available[randi() % available.size()]
			list.append(tier.duplicate(true))
			affix_count -= 1


func _generate_modifiers(tiers: Array[ModifierTier]) -> Array[Modifier]:
	var list: Array[Modifier] = []
	for tier in tiers:
		_append_modifier(tier.modifier, list)
	return list


func _append_modifier(modifier: Modifier, list: Array[Modifier]):
	if not modifier:
		return
	if modifier.submodifiers != null and modifier.submodifiers.size() > 0:
		for submodifier in modifier.submodifiers:
			_append_modifier(submodifier, list)
	else:
		if modifier.has_method("calculate"):
			modifier.calculate()
		list.append(modifier)


func _generate_description(tiers: Array[ModifierTier]) -> Array[ItemDescriptionLine]:
	var lines: Array[ItemDescriptionLine] = []
	var prefixes = tiers.filter(func(tier): return tier.affix_type == ModifierTier.AffixType.PREFIX)
	var suffixes = tiers.filter(func(tier): return tier.affix_type == ModifierTier.AffixType.SUFFIX)
	prefixes.sort_custom(func(a, b): return a.display_priority < b.display_priority)
	suffixes.sort_custom(func(a, b): return a.display_priority < b.display_priority)
	var sorted_tiers: Array[ModifierTier] = []
	sorted_tiers.append_array(prefixes)
	sorted_tiers.append_array(suffixes)
	for tier in sorted_tiers:
		var description = tier.modifier.get_description()
		if description == null || description == "":
			continue
		var line = ItemDescriptionLine.new()
		var stat_modifier = tier.modifier as StatModifier
		if stat_modifier and _modifier_icons.has(stat_modifier.stat_type):
			line.icon = _modifier_icons[stat_modifier.stat_type]
		line.text = description
		lines.append(line)
	return lines


func _sort_tiers_display(a: ModifierTier, b: ModifierTier) -> bool:
	return a.display_priority < b.display_priority


func _load_bases(path: String):
	var dir = DirAccess.open(path)
	if not dir:
		return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			if file_name.ends_with("tres"):
				var base: ItemBase = load(path + "/" + file_name)
				if base:
					var base_list = Collections.get_dict_array(_item_bases, base.base_type)
					base_list.append(base)
		else:
			_load_bases(path + "/" + file_name)
		file_name = dir.get_next()
	dir.list_dir_end()


func _load_rarities(path: String):
	var dir = DirAccess.open(path)
	if not dir:
		return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			if file_name.ends_with("tres"):
				var rarity: Rarity = load(path + "/" + file_name)
				_rarities.append(rarity)
		file_name = dir.get_next()
	dir.list_dir_end()
	_rarities.sort_custom(func(a, b): return a.rate < b.rate)


func _load_tiers():
	_process_directory("res://src/modifiers")


func _load_modifier_icons():
	for type in StatConstants.STAT_ICONS.keys():
		var res = StatConstants.STAT_ICONS[type]
		if Strings.is_null_or_empty(res):
			continue
		_modifier_icons[type] = load(res)


func _process_directory(path: String):
	var dir = DirAccess.open(path)
	if not dir:
		return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			if file_name == "tiers":
				_process_tiers(path + "/" + file_name)
			else:
				_process_directory(path + "/" + file_name)
		file_name = dir.get_next()
	dir.list_dir_end()


func _process_tiers(path: String):
	var dir = DirAccess.open(path)
	if not dir:
		return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			if file_name.ends_with("tres"):
				var tier: ModifierTier = load(path + "/" + file_name)
				_tiers.append(tier)
				for type in ItemConstants.ItemType:
					var idx: int = ItemConstants.ItemType[type]
					if idx & tier.item_type == idx:
						var type_map = Collections.get_dict_dict(_tier_map, idx)
						var affix_map = Collections.get_dict_dict(type_map, tier.affix_type)
						var tier_list = Collections.get_dict_array(affix_map, tier.tier_group)
						tier_list.append(tier)
		file_name = dir.get_next()
	dir.list_dir_end()
