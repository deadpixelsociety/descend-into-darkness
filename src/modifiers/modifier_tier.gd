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
@export_flags("Axe", "Bow", "Dagger", "Mace", "Staff", "Sword", "Wand", "Armour", "Boots", "Helm", "Necklace", "Ring", "Shield", "Focus") 
var item_type: int
@export var item_level_min: int
@export var modifier: Modifier
@export var autoload_tier: bool = true
