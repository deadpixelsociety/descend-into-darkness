extends Control
class_name ItemPreview

@export var item_def: ItemDefinition:
	set(value):
		item_def = value
		_setup_preview()

@onready var _texture: TextureRect = $TextureRect


func _ready():
	_setup_preview()


func _setup_preview():
	if _texture:
		_texture.texture = item_def.item_base.icon
