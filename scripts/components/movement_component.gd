class_name MovementComponent
extends Node2D


signal direction_changed
signal movement_started
signal movement_stopped
signal dash_availability_changed
signal dash_timer_timeout
signal dash_cooldown_timer_timeout


@export_group("Movement", "move")
@export var move_speed: float = 100.0
@export var move_acceleration: float = 1000.0
@export var move_friction: float = 1000.0

@export_group("Dash", "dash")
@export var dash_force: float = 2.0
@export var dash_duration: float = 0.2
@export var dash_cooldown_duration: float = 1.0

var direction := Vector2.ZERO:
	get = _get_direction, set = _set_direction

var can_dash := true:
	get = _get_can_dash, set = _set_can_dash

@onready var dash_timer: Timer = null
@onready var dash_cooldown_timer: Timer = null


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


func _get_can_dash() -> bool:
	return can_dash


func _set_can_dash(value: bool) -> void:

	if value == can_dash:
		return

	can_dash = value
	dash_availability_changed.emit()


func set_dash_timer(duration: float) -> void:

	if dash_timer == null:

		dash_timer = Timer.new()
		dash_timer.one_shot = true
		add_child(dash_timer)

	if dash_timer.timeout.is_connected(_on_dash_timer_timeout):
		dash_timer.timeout.disconnect(_on_dash_timer_timeout)

	dash_timer.timeout.connect(_on_dash_timer_timeout)
	dash_timer.start(duration)


func _on_dash_timer_timeout() -> void:
	dash_timer_timeout.emit()


func set_dash_cooldown_timer(duration: float) -> void:

	if dash_cooldown_timer == null:

		dash_cooldown_timer = Timer.new()
		dash_cooldown_timer.one_shot = true
		add_child(dash_cooldown_timer)

	if dash_cooldown_timer.timeout.is_connected(_on_dash_cooldown_timer_timeout):
		dash_cooldown_timer.timeout.disconnect(_on_dash_cooldown_timer_timeout)

	dash_cooldown_timer.timeout.connect(_on_dash_cooldown_timer_timeout)
	can_dash = false
	dash_cooldown_timer.start(duration)


func _on_dash_cooldown_timer_timeout() -> void:
	can_dash = true
	dash_cooldown_timer_timeout.emit()


func move(delta: float) -> void:

	var target_velocity: Vector2 = direction * move_speed
	var rate: float = (move_acceleration if direction else move_friction) * delta

	owner.velocity = owner.velocity.move_toward(target_velocity, rate)


func dash(delta: float) -> void:

	if not can_dash:
		return

	var target_velocity: Vector2 = direction.sign() * move_speed
	var rate: float = (move_acceleration if direction else move_friction) * delta

	owner.velocity = owner.velocity.move_toward(target_velocity, rate) * dash_force

	set_dash_timer(dash_duration)
	set_dash_cooldown_timer(dash_cooldown_duration)
