extends Area2D
class_name SpawnArea

const CELL_SIZE = 96.0
const MIN_SPAWN_DISTANCE = 192.0

var _cells: Array[Rect2] = []
var _available_cells: Array[Rect2] = []

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D


func _ready():
	_create_cells()


func get_spawn_point() -> Vector2:
	var extents = _get_available_cell()
	var v = Vector2(randfn(0.5, 0.2), randfn(0.5, 0.2))
	return extents.position + (v * extents.size)


func _create_cells():
	var extents = _get_extents()
	for y in range(extents.position.y, extents.end.y, CELL_SIZE):
		for x in range(extents.position.x, extents.end.x, CELL_SIZE):
			var pos = _collision_shape.position + Vector2(x, y)
			var size = Vector2(CELL_SIZE, CELL_SIZE)
			if pos.x + size.x > extents.end.x:
				size.x = extents.end.x - pos.x
				size.x -= abs(_collision_shape.position.x)
			if pos.y + size.y > extents.end.y:
				size.y = extents.end.y - pos.y
				size.y -= abs(_collision_shape.position.y)
			_cells.append(Rect2(pos, size))


func _reset_available_cells():
	_available_cells.clear()
	_available_cells.append_array(_cells)


func _get_available_cell() -> Rect2:
	if _available_cells.size() == 0:
		_reset_available_cells()
	var _temp_cells = _available_cells.duplicate()
	var party_position = Party.get_party_position()
	var cell
	while cell == null and _temp_cells.size() > 0:
		var c = _temp_cells[randi() % _temp_cells.size()]
		var distance = party_position.distance_to(c.get_center())
		if distance >= MIN_SPAWN_DISTANCE:
			cell = c
		else:
			_temp_cells.erase(c)
	if cell:
		_available_cells.erase(cell)
		return cell
	_available_cells.clear()
	return _get_available_cell()


func _get_extents() -> Rect2:
	var shape = _collision_shape.shape as RectangleShape2D
	assert(shape != null)
	var half_size = shape.size * 0.5
	var tl = Vector2(position.x - half_size.x, position.y - half_size.y)
	return Rect2(tl, shape.size)
