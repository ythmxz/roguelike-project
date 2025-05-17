extends State


@export_group("Components")
@export var animation_component: AnimationComponent = null

@export_group("Collisions")
@export var collision: CollisionShape2D = null
@export var hurt_collision: CollisionShape2D = null


func _ready() -> void:
	assert(collision, " A Collision must be selected on PlayerDead!")
	assert(hurt_collision, " A HurtCollision must be selected on PlayerDead!")
	assert(animation_component, "An AnimationComponent must be selected on PlayerDead!")


func enter() -> void:
	collision.call_deferred("disabled", true)
	hurt_collision.call_deferred("disabled", true)
	animation_component.play_animation("dead")
