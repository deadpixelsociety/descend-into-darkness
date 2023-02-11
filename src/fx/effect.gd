extends Sprite2D
class_name Effect


func _ready():
	fade_out()


static func create_hit(hit_type: AttackConstants.HitType) -> Effect:
	var effect = load("res://src/fx/effect.tscn").instantiate() as Effect
	if AttackConstants.HIT_SPRITE_MAP.has(hit_type):
		effect.texture = AttackConstants.HIT_SPRITE_MAP[hit_type]
	effect.modulate = Color.RED
	return effect


func fade_out():
	var tween = create_tween().bind_node(self)
	tween.tween_property(
		self,
		"modulate:a",
		0.0,
		0.3
	)
	tween.tween_callback(queue_free)
	tween.play()
