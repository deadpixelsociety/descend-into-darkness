extends Resource
class_name Attack

@export_category("Attack")
@export var attack_name: String
@export_multiline var description: String
@export var applied_attack: PackedScene
@export_category("Modifiers")
@export var modifiers: Array[Modifier] = []

var id: String = Guid.generate()
