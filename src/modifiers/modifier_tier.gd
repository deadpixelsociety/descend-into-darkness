extends Resource
class_name ModifierTier

enum AffixType {
	PREFIX,
	SUFFIX
}

@export_category("Tier")
@export var tier_name: String
@export var tier_group: String
@export var affix_type: AffixType
@export var display_priority: int = 0
@export_flags("Weapon", "Armour", "Boots", "Gloves", "Helm", "Leggings", "Necklace", "Ring", "Offhand") var item_type: int
@export var item_level_min: int
@export var modifier: Modifier
