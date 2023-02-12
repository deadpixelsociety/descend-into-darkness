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

var _piece_map = {}


func _init():
	_load_pieces()
	pass


func get_textures(piece: PortraitConstants.Piece) -> Array:
	return _piece_map[piece]


func _load_pieces():
	for piece in PIECE_PATH_MAP.keys():
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
