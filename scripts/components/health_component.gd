class_name HealthComponent
extends Node2D


signal max_health_changed
signal health_changed
signal health_depleted
signal invincibility_changed
signal invincibility_timer_timeout


@export var max_health: int = 1:
	get = _get_max_health, set =_set_max_health

@onready var health: int = max_health:
	get = _get_health, set = _set_health

var is_invincible := false:
	get = _get_is_invincible, set = _set_is_invincible

@onready var invincibility_timer: Timer = null


func _get_max_health() -> int:
	return max_health


func _set_max_health(value: int) -> void:

	value = clampi(value, 1, value)

	if value == max_health:
		return

	max_health = value
	max_health_changed.emit()

	if health > max_health:
		health = max_health


func _get_health() -> int:
	return health


func _set_health(value: int) -> void:

	if value < health and is_invincible:
		return

	value = clampi(value, 0, max_health)

	if value == health:
		return

	health = value
	health_changed.emit()

	if health == 0:
		health_depleted.emit()


func _get_is_invincible() -> bool:
	return is_invincible


func _set_is_invincible(value: bool) -> void:

	if value == is_invincible:
		return

	is_invincible = value
	invincibility_changed.emit()


func set_invincibility_timer(duration: float) -> void:

	if invincibility_timer == null:

		invincibility_timer = Timer.new()
		invincibility_timer.one_shot = true
		add_child(invincibility_timer)

	if invincibility_timer.timeout.is_connected(_on_invincibility_timer_timeout):
		invincibility_timer.timeout.disconnect(_on_invincibility_timer_timeout)

	invincibility_timer.timeout.connect(_on_invincibility_timer_timeout)
	is_invincible = true
	invincibility_timer.start(duration)


func _on_invincibility_timer_timeout() -> void:
	is_invincible = false
	invincibility_timer_timeout.emit()
