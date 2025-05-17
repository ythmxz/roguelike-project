class_name Player
extends CharacterBody2D


@export_group("Components")
@export var health_component: HealthComponent = null
@export var hurtbox_component: HurtboxComponent = null
@export var movement_component: MovementComponent = null
@export var animation_component: AnimationComponent = null
@export var state_machine: StateMachine = null


func _ready() -> void:
	assert(health_component, "A HealthComponent must be selected on Player!")
	assert(hurtbox_component, "A HurtboxComponent must be selected on Player!")
	assert(movement_component, "A Movement must be selected on Player!")
	assert(animation_component, "An Animation must be selected on Player!")
	assert(state_machine, "A StateMachine must be selected on Player!")


func _physics_process(_delta: float) -> void:
	move_and_slide()
