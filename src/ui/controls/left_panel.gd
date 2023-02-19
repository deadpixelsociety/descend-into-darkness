extends Control
class_name LeftPanel

@onready var _hero_container_1: HeroContainer = %HeroContainer1
@onready var _hero_container_2: HeroContainer = %HeroContainer2
@onready var _hero_container_3: HeroContainer = %HeroContainer3
@onready var _hero_container_4: HeroContainer = %HeroContainer4
@onready var _inventory_panel: Control = %InventoryPanel


func _on_inventory_button_pressed() -> void:
	_inventory_panel.modulate.a = 0.0
	_inventory_panel.visible = not _inventory_panel.visible
	var tween = create_tween().bind_node(self)
	tween.tween_property(
		_inventory_panel,
		"modulate:a",
		1.0,
		0.1
	)
	tween.play()
