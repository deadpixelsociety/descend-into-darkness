extends OnHitEffect
class_name LeechEffect


func _effect_start():
	GlobalEffects.leech_trail(_applicator, global_position)
	GlobalEffects.bite(_target)
