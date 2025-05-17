class_name HitboxComponent
extends Area2D


@export var damage: int = 1:
	get = _get_damage, set = _set_damage


func _get_damage() -> int:
	return damage


func _set_damage(value: int) -> void:

	if value == damage:
		return

	damage = value
