extends Node2D
class_name MonsterSpawner

@export var spawn_area: SpawnArea
@export var entities: Node2D

var SPAWN_EFFECT: PackedScene = load("res://src/fx/spawn_effect.tscn")

var _repository: MonsterRepository = MonsterRepository.new()


func spawn_monsters(count: int):
	var monsters = _repository.generate_monsters(count, Party.get_level())
	for monster_type in monsters:
		var monster = monster_type.monster.instantiate()
		var spawn_point = spawn_area.get_spawn_point()
		_spawn_monster(monster, spawn_point)


func _spawn_monster(monster: Monster, spawn_point: Vector2):
	var effect = SPAWN_EFFECT.instantiate() as SpawnEffect
	effect.position = spawn_point
	entities.add_child(effect)
	await effect.spawn_finished
	entities.add_child(monster)
	monster.spawn(spawn_point)
