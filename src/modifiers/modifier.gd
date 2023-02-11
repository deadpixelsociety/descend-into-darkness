extends Resource
class_name Modifier

@export_category("Modifier")
@export var modifier_name: String
@export var description_template: String
@export var base_modifier: bool = false
@export var submodifiers: Array[Modifier] = []

var ownder_id: String


func get_description(override_value: float = 0.0) -> String:
	return description_template
