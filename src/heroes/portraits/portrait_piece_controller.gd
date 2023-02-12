extends HBoxContainer
class_name PortraitPieceController

signal piece_changed(piece_type, texture)

@export var piece_type: PortraitConstants.Piece
@export var repository: PortraitRepository
@export var first_is_blank: bool = false

var BLANK = load("res://assets/textures/portraits/blank.png")

var _index: int = 0
var _textures: Array = []

@onready var _label: Label = $PieceLabel


func _ready():
	EventBus.randomize_portrait.connect(_on_randomize_portrait)
	EventBus.reset_portrait.connect(_on_reset_portrait)
	_setup_controller()
	_update_label()
	if _textures.size() > 0:
		piece_changed.emit(piece_type, _textures[0])


func _setup_controller():
	_textures.clear()
	if not repository:
		return
	if first_is_blank:
		_textures.append(BLANK)
	_textures.append_array(repository.get_textures(piece_type))


func _update_label():
	if not _label:
		return
	var num = _index + 1
	var piece_name = PortraitConstants.PIECE_NAMES[piece_type]
	_label.text = "%s %02d" % [ piece_name, num ]


func _check_rules():
	match piece_type:
		PortraitConstants.Piece.HELM:
			var hidden = range(4, 11).has(_index)
			EventBus.change_portrait_piece_visibility.emit(PortraitConstants.Piece.HAIR, hidden)


func _update_piece():
	piece_changed.emit(piece_type, _textures[_index])
	_update_label()
	_check_rules()
	

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


func _on_randomize_portrait():
	_index = randi() % _textures.size()
	_update_piece()


func _on_reset_portrait():
	_index = 0
	_update_piece()
