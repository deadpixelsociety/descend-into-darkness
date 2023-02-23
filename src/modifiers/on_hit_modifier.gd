extends StatModifier
class_name OnHitModifier

enum OnHitType {
	LEECH,
	BURN,
	BLEED,
	POISON,
	SHOCK,
	CHILL,
	CUSTOM
}

enum OnHitApplication {
	STACK,
	REFRESH,
	ONE_SHOT
}

@export_category("On Hit")
@export var on_hit_tyoe: OnHitType
@export var on_hit_chance: float = 0.0
@export var on_hit_value: float = 0.0
@export var on_hit_duration: float = 0.0
@export var on_hit_effect: PackedScene
# When applying the hit effect, how are multiple applications handled?
# Stack - A number of instances of the effect, up to on_hit_stacks, can exist.
# Refresh - The existing instance of the effect is refreshed for duration
#			and the higher value between the two is used.
# One Shot - The effect is instant and will not linger so existing applications 
#			are ignored.
@export var on_hit_application: OnHitApplication
@export var on_hit_stacks: int


func accumulate(data: Dictionary):
	data["base"] += on_hit_value


func calculate():
	value = on_hit_value
	_calculate_submodifiers()


func _add_custom_template_data(data: Dictionary, template_value: float) -> Dictionary:
	if on_hit_duration > 0.0:
		data["duration"] = "%.0f/s" % on_hit_duration
	else:
		data["duration"] = ""
	return data


func can_apply_effect(target: Node2D) -> bool:
	match on_hit_application:
		OnHitModifier.OnHitApplication.STACK:
			var stacks = GameUtil.get_stack_count(target, on_hit_tyoe)
			return stacks < on_hit_stacks
		_:
			return true
