extends State


@export_group("States")
@export var player_idle: State = null
@export var player_dead: State = null

@export_group("Components")
@export var health_component: HealthComponent = null
@export var movement_component: MovementComponent = null
@export var animation_component: AnimationComponent = null

@export_group("Durations")
@export var invincibility_duration: float = 1.0
@export var hurt_duration: float = 0.2

@onready var hurt_timer: Timer = null


func _ready() -> void:

	assert(player_idle, "A PlayerIdle State must be selected on PlayerWalk!")
	assert(player_dead, "A PlayerDead State must be selected on PlayerWalk!")

	assert(health_component, "A HealthComponent must be selected on PlayerIdle!")
	assert(movement_component, "A MovementComponent must be selected on PlayerIdle!")
	assert(animation_component, "An AnimationComponent must be selected on PlayerIdle!")


func enter() -> void:

	if not health_component.health_depleted.is_connected(_on_health_depleted):
		health_component.health_depleted.connect(_on_health_depleted)

	_set_hurt_timer(hurt_duration)
	health_component.set_invincibility_timer(invincibility_duration)
	animation_component.play_animation("hurt")


func update(_delta: float) -> void:
	animation_component.set_flip_angle(animation_component.mouse_angle)


func physics_update(delta: float) -> void:
	movement_component.direction = Vector2.ZERO
	movement_component.move(delta)


func _set_hurt_timer(duration: float) -> void:

	if hurt_timer == null:

		hurt_timer = Timer.new()
		hurt_timer.one_shot = true
		add_child(hurt_timer)

	if hurt_timer.timeout.is_connected(_on_hurt_timer_timeout):
		hurt_timer.timeout.disconnect(_on_hurt_timer_timeout)

	hurt_timer.timeout.connect(_on_hurt_timer_timeout)
	hurt_timer.start(duration)


func _on_hurt_timer_timeout() -> void:
	state_machine.change_state(player_idle)


func _on_health_depleted() -> void:
	state_machine.change_state(player_dead)
