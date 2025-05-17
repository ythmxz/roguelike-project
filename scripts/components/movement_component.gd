class_name MovementComponent
extends Node2D


signal direction_changed
signal movement_started
signal movement_stopped


@export_group("Attributes")
@export var move_speed: float = 100.0
@export var acceleration: float = 1000.0
@export var friction: float = 1000.0

var direction := Vector2.ZERO:
	get = _get_direction, set = _set_direction


func _get_direction() -> Vector2:
	return direction


func _set_direction(value: Vector2) -> void:

	value = value.normalized()

	if value == direction:
		return

	direction = value
	direction_changed.emit()

	if direction == Vector2.ZERO:
		movement_stopped.emit()
	else:
		movement_started.emit()


func move(delta: float) -> void:

	var target_velocity: Vector2 = direction * move_speed
	var rate: float = (acceleration if direction else friction) * delta

	owner.velocity = owner.velocity.move_toward(target_velocity, rate)
