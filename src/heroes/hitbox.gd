extends Area2D
class_name Hitbox

signal hitbox_entered(collider)

@export var hitbox_owner: Node2D
@export var collision_shape: CollisionShape2D
@export var auto_disable: bool = true


func _on_hit(collider: Node2D):
	_disable_collision.call_deferred()
	hitbox_entered.emit(collider)
	if collider is Hurtbox:
		if hitbox_owner and hitbox_owner.has_method("deal_damage"):
			hitbox_owner.deal_damage(collider.hurtbox_owner)


func _disable_collision():
	if not auto_disable:
		return
	if collision_shape and is_instance_valid(collision_shape):
		collision_shape.disabled = true


func _on_area_entered(area: Area2D):
	_on_hit(area)


func _on_body_entered(body: Node2D):
	_on_hit(body)
