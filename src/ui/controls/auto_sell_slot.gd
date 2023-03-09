extends PanelContainer
class_name AutoSellSlot


func _can_drop_data(at_position: Vector2, data) -> bool:
	return data is Dictionary and data.has("item_def")


func _drop_data(at_position: Vector2, data):
	var sender = data["sender"]
	var item_def = data["item_def"] as ItemDefinition
	sender.item_def = null
	Party.add_gold(item_def.get_gold_value())
