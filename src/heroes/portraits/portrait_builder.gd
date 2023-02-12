extends Control
class_name PortraitBuilder

var _repository: PortraitRepository = PortraitRepository.new()
var _textures: Dictionary = {}
var _portrait_dirty: bool = false

@onready var _head: TextureRect = %Head
@onready var _eyebrows: TextureRect = %Eyebrows
@onready var _facial_hair: TextureRect = %FacialHair
@onready var _armour: TextureRect = %Armour
@onready var _helm: TextureRect = %Helm
@onready var _tattoo: TextureRect = %Tattoo
@onready var _accessory_1: TextureRect = %Accessory1
@onready var _accessory_2: TextureRect = %Accessory2
@onready var _hair: TextureRect = %Hair
@onready var _render_target: SubViewport = %RenderTarget
@onready var _portrait: TextureRect = %Portrait


func _ready():
	EventBus.change_portrait_piece_visibility.connect(_on_change_portrait_piece_visibility)
	_set_textures()


func _process(delta: float):
	if _portrait_dirty:
		_portrait.texture = _render_target.get_texture()
		_portrait_dirty = false


func _set_textures():
	for piece_type in _textures.keys():
		_set_texture(piece_type, _textures[piece_type])


func _set_texture(piece_type: PortraitConstants.Piece, texture: Texture2D):
	_textures[piece_type] = texture
	match piece_type:
		PortraitConstants.Piece.ACCESSORY_1:
			_set_control_texture(_accessory_1, texture)
		PortraitConstants.Piece.ACCESSORY_2:
			_set_control_texture(_accessory_2, texture)
		PortraitConstants.Piece.ARMOUR:
			_set_control_texture(_armour, texture)
		PortraitConstants.Piece.EYEBROWS:
			_set_control_texture(_eyebrows, texture)
		PortraitConstants.Piece.FACIAL_HAIR:
			_set_control_texture(_facial_hair, texture)
		PortraitConstants.Piece.HAIR:
			_set_control_texture(_hair, texture)
		PortraitConstants.Piece.HEAD:
			_set_control_texture(_head, texture)
		PortraitConstants.Piece.HELM:
			_set_control_texture(_helm, texture)
		PortraitConstants.Piece.TATTOO:
			_set_control_texture(_tattoo, texture)


func _set_control_texture(control: TextureRect, texture: Texture2D):
	if not control:
		return
	control.texture = texture


func _on_piece_changed(piece_type: PortraitConstants.Piece, texture: Texture2D):
	_portrait_dirty = true
	_set_texture(piece_type, texture)


func _on_change_portrait_piece_visibility(piece_type: PortraitConstants.Piece, hidden: bool):
	_portrait_dirty = true
	match piece_type:
		PortraitConstants.Piece.ACCESSORY_1:
			_accessory_1.visible = not hidden
		PortraitConstants.Piece.ACCESSORY_2:
			_accessory_2.visible = not hidden
		PortraitConstants.Piece.ARMOUR:
			_armour.visible = not hidden
		PortraitConstants.Piece.EYEBROWS:
			_eyebrows.visible = not hidden
		PortraitConstants.Piece.FACIAL_HAIR:
			_facial_hair.visible = not hidden
		PortraitConstants.Piece.HAIR:
			_hair.visible = not hidden
		PortraitConstants.Piece.HEAD:
			_head.visible = not hidden
		PortraitConstants.Piece.HELM:
			_helm.visible = not hidden
		PortraitConstants.Piece.TATTOO:
			_tattoo.visible = not hidden


func _on_randomize_pressed() -> void:
	EventBus.randomize_portrait.emit()


func _on_save_pressed() -> void:
	var texture = _render_target.get_texture()
	texture.get_image().save_png("user://portrait.png")


func _on_reset_pressed() -> void:
	EventBus.reset_portrait.emit()
