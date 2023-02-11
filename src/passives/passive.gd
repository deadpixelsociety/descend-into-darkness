extends Resource
class_name Passive

@export_category("Passive")
@export var passive_name: String
@export_multiline var description: String
@export var applied_passive: PackedScene
@export_category("Modifiers")
@export var modifiers: Array[Modifier] = []

var id: String = Guid.generate()
