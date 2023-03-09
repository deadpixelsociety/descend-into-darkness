extends Node2D

var LEECH_TRAIL: PackedScene = load("res://src/fx/leech_trail.tscn")
var BITE: PackedScene = load("res://src/fx/bite.tscn")
var SPARKLE_EXPLOSION: PackedScene = load("res://src/fx/sparkle_explosion.tscn")
var SLASH: PackedScene = load("res://src/fx/slash.tscn")


func add_effect(effect):
	GameUtil.get_entities_container().add_child(effect)


func leech_trail(target: Node2D, start: Vector2):
	var leech_trail = LEECH_TRAIL.instantiate() as LeechTrail
	add_effect(leech_trail)
	leech_trail.spawn(target, start)


func bite(target: Node2D):
	var bite = BITE.instantiate() as Bite
	add_effect(bite)
	bite.spawn(target)


func sparkle_explosion(target: Vector2, tint: Color = Color.WHITE):
	var explosion = SPARKLE_EXPLOSION.instantiate() as SparkleExplosion
	explosion.global_position = target
	explosion.modulate = tint
	explosion.rotation_degrees = 360.0 * randf()
	add_effect(explosion)


func sparkle_explosions(
	target: Vector2, 
	tint: Color = Color.WHITE, 
	num_explosions: int = 2, 
	explosion_radius: float = 8.0,
	explosion_delay: float = 0.1
):
	for i in num_explosions:
		var dir = RandUtil.rand_dir() * (explosion_radius * randf())
		sparkle_explosion(target + dir, tint)
		await get_tree().create_timer(explosion_delay).timeout


func slash(target: Vector2, tint: Color = Color.WHITE):
	var slash = SLASH.instantiate() as Slash
	slash.global_position = target
	slash.modulate = tint
	slash.rotation_degrees = 360.0 * randf()
	add_effect(slash)


func slashes(
	target: Vector2, 
	tint: Color = Color.WHITE, 
	num_slashes: int = 2, 
	slash_radius: float = 8.0,
	slash_delay: float = 0.1
):
	for i in num_slashes:
		var dir = RandUtil.rand_dir() * (slash_radius * randf())
		slash(target + dir, tint)
		await get_tree().create_timer(slash_delay).timeout
