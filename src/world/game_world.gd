extends Node2D
class_name GameWorld

var _counter = 0

@onready var _entities: Node2D = $Entities
@onready var _monster_spawner: MonsterSpawner = $MonsterSpawner


func _ready() -> void:
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
	_spawn_items()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_monster_spawner.spawn_monsters(10)


func _spawn_items():
	var generator = ItemGenerator.new()
	var pickup = load("res://src/items/item_pickup.tscn")
	for i in range(0, 100):
		var weapon = generator.generate_item_type(20, ItemConstants.ItemType.WEAPON)
		var item_pickup = pickup.instantiate() as ItemPickup
		item_pickup.item_def = weapon
		item_pickup.position = RandUtil.rand_vector2() * Vector2(300, 200)
		_entities.add_child(item_pickup)
