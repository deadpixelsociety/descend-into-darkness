extends VBoxContainer
class_name GameRightPanel

@export var fixed_size: Vector2

@onready var _gold: Label = %Gold
@onready var _xp_vial: ResourceVialHorizontal = %XPVial


func _ready():
	Party.gold_changed.connect(_on_gold_changed)
	_on_gold_changed()


func _on_gold_changed():
	_gold.text = Formatter.format_float(Party.get_gold())
