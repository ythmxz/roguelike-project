extends State


@export_group("States")
@export var player_idle: State = null
@export var player_hurt: State = null

@export_group("Components")
@export var hurtbox_component: HurtboxComponent = null
@export var movement_component: MovementComponent = null
@export var animation_component: AnimationComponent = null


func _ready() -> void:

	assert(player_idle, "A PlayerIdle State must be selected on PlayerWalk!")
	assert(player_hurt, "A PlayerHurt State must be selected on PlayerWalk!")

	assert(hurtbox_component, "A HurtboxComponent must be selected on PlayerIdle!")
	assert(movement_component, "A MovementComponent must be selected on PlayerIdle!")
	assert(animation_component, "An AnimationComponent must be selected on PlayerIdle!")


func enter() -> void:
	hurtbox_component.damage_taken.connect(_on_damage_taken)
	movement_component.movement_stopped.connect(_on_movement_stopped)
	animation_component.play_animation("walk")


func exit() -> void:
	hurtbox_component.damage_taken.disconnect(_on_damage_taken)
	movement_component.movement_stopped.disconnect(_on_movement_stopped)


func update(_delta: float) -> void:
	animation_component.set_flip_angle(animation_component.mouse_angle)


func physics_update(delta: float) -> void:
	movement_component.direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	movement_component.move(delta)


func _on_damage_taken() -> void:
	state_machine.change_state(player_hurt)


func _on_movement_stopped() -> void:
	state_machine.change_state(player_idle)
