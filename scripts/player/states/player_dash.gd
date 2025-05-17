extends State


@export_group("States")
@export var player_idle: State = null
@export var player_hurt: State = null

@export_group("Components")
@export var health_component: HealthComponent = null
@export var hurtbox_component: HurtboxComponent = null
@export var movement_component: MovementComponent = null
@export var animation_component: AnimationComponent = null


func _ready() -> void:

	assert(player_idle, "A PlayerIdle State must be selected on PlayerDash!")
	assert(player_hurt, "A PlayerHurt State must be selected on PlayerDash!")

	assert(health_component, "A HealthComponent must be selected on PlayerDash!")
	assert(hurtbox_component, "A HurtboxComponent must be selected on PlayerDash!")
	assert(movement_component, "A MovementComponent must be selected on PlayerDash!")
	assert(animation_component, "An AnimationComponent must be selected on PlayerDash!")


func enter() -> void:
	hurtbox_component.damage_taken.connect(_on_damage_taken)
	movement_component.dash_timer_timeout.connect(_on_dash_timer_timeout)
	animation_component.set_flip_direction(movement_component.direction)
	animation_component.play_animation("dash")


func  exit() -> void:
	hurtbox_component.damage_taken.disconnect(_on_damage_taken)
	movement_component.dash_timer_timeout.disconnect(_on_dash_timer_timeout)


func physics_update(delta: float) -> void:
	movement_component.direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	movement_component.dash(delta)
	movement_component.direction = Vector2.ZERO


func _on_damage_taken() -> void:

	if not health_component.is_invincible:
		state_machine.change_state(player_hurt)


func _on_dash_timer_timeout() -> void:
	state_machine.change_state(player_idle)
