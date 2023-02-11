extends Resource
class_name Rarity

@export_category("Rarity")
@export var rarity_name: String
@export var color: Color
@export var rate: float
@export var prefixes_min: int
@export var prefixes_max: int
@export var suffixes_min: int
@export var suffixes_max: int
@export_category("Particles")
@export var particles_enabled: bool = true
@export var particle_scale: float = 1.0
