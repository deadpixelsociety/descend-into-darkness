extends Node2D
class_name GameWorld

var ITEM_PICKUP: PackedScene = load("res://src/items/item_pickup.tscn")

var _counter = 0

@onready var _entities: Node2D = $Entities
@onready var _monster_spawner: MonsterSpawner = $MonsterSpawner
@onready var _portrait_repository: PortraitRepository = $PortraitRepository


func _ready() -> void:
	EventBus.item_dropped.connect(_on_item_dropped)
	var hero = load("res://src/heroes/hero.tscn").instantiate() as Hero
	hero.hero_class = load("res://src/heroes/classes/barbarian.tres")
	var hero2 = load("res://src/heroes/hero.tscn").instantiate() as Hero
	hero2.hero_class = load("res://src/heroes/classes/cleric.tres")
	var hero3 = load("res://src/heroes/hero.tscn").instantiate() as Hero
	hero3.hero_class = load("res://src/heroes/classes/wizard.tres")
	var hero4 = load("res://src/heroes/hero.tscn").instantiate() as Hero
	hero4.hero_class = load("res://src/heroes/classes/thief.tres")
	Party.add_hero(hero)
	Party.add_hero(hero2)
	Party.add_hero(hero3)
	Party.add_hero(hero4)
	_entities.add_child(hero)
	_entities.add_child(hero2)
	_entities.add_child(hero3)
	_entities.add_child(hero4)
	Party.set_hero_name(hero, "Deadly Pixel")
	Party.set_hero_name(hero2, "Dark Sylvan")
	Party.set_hero_name(hero3, "Jonny Walker")
	Party.set_hero_name(hero4, "Ron Cheese")
	Party.set_portrait(hero, _portrait_repository.get_random_portrait())
	Party.set_portrait(hero2, _portrait_repository.get_random_portrait())
	Party.set_portrait(hero3, _portrait_repository.get_random_portrait())
	Party.set_portrait(hero4, _portrait_repository.get_random_portrait())
	_spawn_items()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_monster_spawner.spawn_monsters(1)


func _spawn_items():
	var pickup = load("res://src/items/item_pickup.tscn")
	for i in range(0, 1):
		var item_set: Array[ItemConstants.ItemType] = [
#			ItemConstants.ItemType.BOOTS,
#			ItemConstants.ItemType.CHEST,
			#ItemConstants.ItemType.HELM,
#			ItemConstants.ItemType.RING,
#			ItemConstants.ItemType.NECKLACE,
#			ItemConstants.ItemType.SHIELD,
#			ItemConstants.ItemType.FOCUS,
			ItemConstants.ItemType.WEAPON_SWORD
		]
		var weapon_types = Party.get_weapon_types()
#		item_set.append_array(weapon_types)
		var weapon = ItemGenerator.generate_unique(10, ItemConstants.ItemType.FOCUS)
		var item_pickup = pickup.instantiate() as ItemPickup
		item_pickup.item_def = weapon
		item_pickup.position = RandUtil.rand_vector2() * Vector2(300, 200)
		_entities.add_child(item_pickup)


func _on_item_dropped(item_def: ItemDefinition):
	var pickup = ITEM_PICKUP.instantiate() as ItemPickup
	pickup.item_def = item_def
	var leader = Party.get_leader()
	if not leader:
		return
	pickup.global_position = leader.global_position
	_entities.add_child(pickup)
	pickup.drop()
