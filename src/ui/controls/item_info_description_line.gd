extends HBoxContainer
class_name ItemInfoDescriptionLine

@onready var _icon: TextureRect = $TextureRect
@onready var _text: Label = $ItemDescription


func set_description(line: ItemDescriptionLine):
	_icon.texture = line.icon
	_icon.visible = line.icon != null
	_text.text = line.text
