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


func get_gold_value() -> int:
	var gold = rarity.gold_base
	gold += (tiers.size() * 2)
	if ItemConstants.JEWELRY_TYPES.has(item_type):
		gold += 10
	gold *= item_level
	return gold
