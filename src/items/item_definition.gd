extends Resource
class_name ItemDefinition

@export_category("Item")
@export var item_name: String
@export var description_lines: Array[ItemDescriptionLine]
@export var item_level: int
@export var item_type: ItemConstants.ItemType
@export var item_base: ItemBase
@export var rarity: Rarity
@export var tiers: Array[ModifierTier] = []
@export var modifiers: Array[Modifier] = []

var id: String = Guid.generate()
