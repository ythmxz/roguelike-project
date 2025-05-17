extends State


@export_group("States")
@export var player_walk: State = null
@export var player_hurt: State = null

@export_group("Components")
@export var health_component: HealthComponent = null
@export var hurtbox_component: HurtboxComponent = null
@export var movement_component: MovementComponent = null
@export var animation_component: AnimationComponent = null


func _ready() -> void:

	assert(player_walk, "A PlayerWalk State must be selected on PlayerWalk!")
	assert(player_hurt, "A PlayerHurt State must be selected on PlayerWalk!")

	assert(health_component, "A HealthComponent must be selected on PlayerIdle!")
	assert(hurtbox_component, "A HurtboxComponent must be selected on PlayerIdle!")
	assert(movement_component, "A MovementComponent must be selected on PlayerIdle!")
	assert(animation_component, "An AnimationComponent must be selected on PlayerIdle!")


func enter() -> void:
	hurtbox_component.damage_taken.connect(_on_damage_taken)
	movement_component.movement_started.connect(_on_movement_started)
	animation_component.play_animation("idle")


func exit() -> void:
	hurtbox_component.damage_taken.disconnect(_on_damage_taken)
	movement_component.movement_started.disconnect(_on_movement_started)


func update(_delta: float) -> void:
	animation_component.set_flip_angle(animation_component.mouse_angle)


func physics_update(delta: float) -> void:
	movement_component.direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	movement_component.move(delta)


func _on_damage_taken() -> void:

	if not health_component.is_invincible:
		state_machine.change_state(player_hurt)


func _on_movement_started() -> void:
	state_machine.change_state(player_walk)
