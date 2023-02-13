extends Control
class_name PortraintContainer

@export var portrait_repository: PortraitRepository

var _data: Dictionary = {}

@onready var _head: TextureRect = %Head
@onready var _eyebrows: TextureRect = %Eyebrows
@onready var _facial_hair: TextureRect = %FacialHair
@onready var _armour: TextureRect = %Armour
@onready var _tattoo: TextureRect = %Tattoo
@onready var _accessory_1: TextureRect = %Accessory1
@onready var _accessory_2: TextureRect = %Accessory2
@onready var _hair: TextureRect = %Hair
@onready var _helm: TextureRect = %Helm


func set_portrait_data(data: Dictionary):
	_data = data
	if not portrait_repository:
		return
	for piece_type in data.keys():
		var index = data[piece_type]
		var control = _get_piece_control(piece_type)
		if not control:
			continue
		control.texture = portrait_repository.get_textures(piece_type)[index]
		control.set_meta("index", index)
	_apply_rules()


func get_portrait_data() -> Dictionary:
	var data = {}
	for piece_type in PortraitConstants.Piece:
		var piece = PortraitConstants.Piece[piece_type]
		var control = _get_piece_control(piece)
		if not control:
			continue
		if control.has_meta("index"):
			data[piece] = int(control.get_meta("index", 0))
		else:
			data[piece] = 0
	return data


func randomize_portrait():
	set_portrait_data(portrait_repository.get_random_portrait())


func _get_piece_control(piece_type: PortraitConstants.Piece) -> TextureRect:
	match piece_type:
		PortraitConstants.Piece.ACCESSORY_1:
			return _accessory_1
		PortraitConstants.Piece.ACCESSORY_2:
			return _accessory_2
		PortraitConstants.Piece.ARMOUR:
			return _armour
		PortraitConstants.Piece.EYEBROWS:
			return _eyebrows
		PortraitConstants.Piece.FACIAL_HAIR:
			return _facial_hair
		PortraitConstants.Piece.HAIR:
			return _hair
		PortraitConstants.Piece.HEAD:
			return _head
		PortraitConstants.Piece.HELM:
			return _helm
		PortraitConstants.Piece.TATTOO:
			return _tattoo
	return null


func _apply_rules():
	for piece_type in PortraitConstants.Piece:
		var piece = PortraitConstants.Piece[piece_type]
		var index = 0
		if _data.has(piece):
			index = _data[piece]
		var control = _get_piece_control(piece)
		if not control:
			continue
		match piece:
			PortraitConstants.Piece.HELM:
				control.visible = range(4, 11).has(index)
			PortraitConstants.Piece.ACCESSORY_1:
				control.z_index = 99 if [3, 21].has(index) else 0
			PortraitConstants.Piece.ACCESSORY_2:
				control.z_index = 99 if [3, 21].has(index) else 0
