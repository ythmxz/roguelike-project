class_name StateMachine
extends Node


signal state_changed


@export var initial_state: State = null
var current_state: State = null


func _ready() -> void:
	assert(initial_state, "An initial State must be selected!")
	change_state(initial_state)


func _unhandled_input(event: InputEvent) -> void:
	current_state.handle_input(event)


func _process(delta: float) -> void:
	current_state.update(delta)


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


func change_state(new_state: State) -> void:

	if new_state == current_state:
		return

	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.state_machine = self
	current_state.enter()
	state_changed.emit()
