extends AppliedAttack
class_name DivineAura

@export var rotation_speed: float = 45.0

var _pulse_timer: float = 0.0

@onready var _aura: Sprite2D = $Aura
@onready var _damage_pulse: Timer = $DamagePulse


func _process(delta: float):
	_pulse_timer += delta
	_aura.scale = Vector2.ONE + (Vector2.ONE * sin(_pulse_timer) * 0.1)


func configure_attack():
	super.configure_attack()
	_damage_pulse.wait_time = get_hero().get_attack_time()


func _on_damage_pulse_timeout() -> void:
	pass
