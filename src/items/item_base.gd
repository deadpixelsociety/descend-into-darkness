extends Resource
class_name ItemBase

@export_category("Item Base")
@export var base_name: String
@export var base_type: ItemConstants.ItemType
@export var icon: Texture
@export var modifiers: Array[Modifier] = []
