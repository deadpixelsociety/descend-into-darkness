extends HBoxContainer
class_name PortraitPieceController

signal piece_changed(piece_type, index, texture)

@export var piece_type: PortraitConstants.Piece
@export var repository: PortraitRepository


var _index: int = 0
var _textures: Array = []

@onready var _label: Label = $PieceLabel


func _ready():
	EventBus.portrait_changed.connect(_on_portrait_changed)
	EventBus.reset_portrait.connect(_on_reset_portrait)
	_setup_controller()
	_update_label()
	if _textures.size() > 0:
		piece_changed.emit(piece_type, 0, _textures[0])


func _setup_controller():
	_textures.clear()
	if not repository:
		return
	_textures.append_array(repository.get_textures(piece_type))


func _update_label():
	if not _label:
		return
	var num = _index + 1
	var piece_name = PortraitConstants.PIECE_NAMES[piece_type]
	_label.text = "%s %02d" % [ piece_name, num ]


func _update_piece():
	piece_changed.emit(piece_type, _index, _textures[_index])
	_update_label()
	

func _on_piece_left_pressed() -> void:
	if _textures.size() == 0:
		return
	_index -= 1
	if _index < 0:
		_index = _textures.size() - 1
	_update_piece()


func _on_piece_right_pressed() -> void:
	if _textures.size() == 0:
		return
	_index += 1
	if _index >= _textures.size():
		_index = 0
	_update_piece()


func _on_portrait_changed(data: Dictionary):
	if data.has(piece_type):
		_index = data[piece_type]
		_update_piece()


func _on_reset_portrait():
	_index = 0
	_update_piece()
