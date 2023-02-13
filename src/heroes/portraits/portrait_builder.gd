extends Control
class_name PortraitBuilder

@export var hero: Hero

var _repository: PortraitRepository = PortraitRepository.new()
var _data: Dictionary = {}

@onready var _portrait_container: PortraintContainer = %PortraitContainer


func _ready():
	_data = Party.get_portrait(hero)
	_portrait_container.set_portrait_data(_data)


func _on_piece_changed(
	piece_type: PortraitConstants.Piece, 
	index: int, 
	texture: Texture2D
):
	_data[piece_type] = index
	if _portrait_container:
		_portrait_container.set_portrait_data(_data)


func _on_randomize_pressed():
	_portrait_container.randomize_portrait()
	EventBus.portrait_changed.emit(_portrait_container.get_portrait_data())


func _on_save_pressed():
	Party.set_portrait(hero, _portrait_container.get_portrait_data())


func _on_reset_pressed():
	EventBus.reset_portrait.emit()
