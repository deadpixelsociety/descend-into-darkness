extends Node
class_name PortraitRepository

const PIECE_PATH_MAP = {
	PortraitConstants.Piece.ACCESSORY_1: "res://assets/textures/portraits/accessory/",
	PortraitConstants.Piece.ACCESSORY_2: "res://assets/textures/portraits/accessory/",
	PortraitConstants.Piece.ARMOUR: "res://assets/textures/portraits/armour/",
	PortraitConstants.Piece.EYEBROWS: "res://assets/textures/portraits/eyebrows/",
	PortraitConstants.Piece.FACIAL_HAIR: "res://assets/textures/portraits/facial_hair/",
	PortraitConstants.Piece.HAIR: "res://assets/textures/portraits/hair/",
	PortraitConstants.Piece.HEAD: "res://assets/textures/portraits/head/",
	PortraitConstants.Piece.HELM: "res://assets/textures/portraits/helm/",
	PortraitConstants.Piece.TATTOO: "res://assets/textures/portraits/tattoo/"
}

const BLANK_PIECES = [
	PortraitConstants.Piece.ACCESSORY_1,
	PortraitConstants.Piece.ACCESSORY_2,
	PortraitConstants.Piece.ARMOUR,
	PortraitConstants.Piece.EYEBROWS,
	PortraitConstants.Piece.FACIAL_HAIR,
	PortraitConstants.Piece.HAIR,
	PortraitConstants.Piece.HELM,
	PortraitConstants.Piece.TATTOO
]

var BLANK = load("res://assets/textures/portraits/blank.png")
var _piece_map = {}


func _init():
	_load_pieces()


func get_textures(piece: PortraitConstants.Piece) -> Array:
	return _piece_map[piece]


func get_random_portrait() -> Dictionary:
	var data = {}
	for piece_type in PortraitConstants.Piece:
		var piece = PortraitConstants.Piece[piece_type]
		var textures = get_textures(piece)
		match piece:
			PortraitConstants.Piece.ACCESSORY_1:
				if RandUtil.rand_bool(0.7):
					continue
			PortraitConstants.Piece.ACCESSORY_2:
				if RandUtil.rand_bool(0.4):
					continue
			PortraitConstants.Piece.EYEBROWS:
				if RandUtil.rand_bool(0.8):
					continue
			PortraitConstants.Piece.FACIAL_HAIR:
				if RandUtil.rand_bool(0.7):
					continue
			PortraitConstants.Piece.HELM:
				if RandUtil.rand_bool(0.6):
					continue
			PortraitConstants.Piece.TATTOO:
				if RandUtil.rand_bool(0.8):
					continue
		data[piece] = randi() % textures.size()
	return data


func _load_pieces():
	for piece in PIECE_PATH_MAP.keys():
		var texture_list = Collections.get_dict_array(_piece_map, piece)
		if BLANK_PIECES.has(piece):
			texture_list.append(BLANK)
		var path = PIECE_PATH_MAP[piece]
		_load_dir(piece, path)


func _load_dir(piece: PortraitConstants.Piece, path: String):
	var dir = DirAccess.open(path)
	if not dir:
		return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			if file_name.ends_with("png"):
				var texture: Texture2D = load(path + "/" + file_name)
				if texture:
					var texture_list = Collections.get_dict_array(_piece_map, piece)
					texture_list.append(texture)
		file_name = dir.get_next()
	dir.list_dir_end()
