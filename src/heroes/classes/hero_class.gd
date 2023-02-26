extends Resource
class_name HeroClass

@export_category("Hero Class")
@export var hero_name: String
@export_multiline var description: String
@export var hero_tag: String
@export var hero_color: Color
@export_category("Abilities")
@export var attack: Attack
@export var passive: Passive
@export var can_dual_wield: bool = false
@export_category("Animation")
@export var sprite_frames: SpriteFrames
@export_category("Items")
@export_flags("Axe", "Bow", "Dagger", "Mace", "Staff", "Sword", "Wand")
var weapon_type: int
@export var equipment: Array[ItemBase] = []
@export_category("Modifiers")
@export var modifiers: Array[Modifier] = []

var id: String = Guid.generate()
