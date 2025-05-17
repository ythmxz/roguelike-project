class_name AnimationComponent
extends Node2D


@export var sprite: AnimatedSprite2D = null

var mouse_angle: float = 0.0:
	get = _get_mouse_angle


func _ready() -> void:
	assert(sprite, "A Sprite must be selected on AnimationComponent!")


func _get_mouse_angle() -> float:
	return rad_to_deg((get_global_mouse_position() - owner.global_position).angle())


func play_animation(value: String) -> void:

	if value == sprite.animation:
		return

	sprite.play(value)


func set_flip_direction(direction: Vector2) -> void:

	if direction.x > 0.0:
		sprite.flip_h = false
	if direction.x < 0.0:
		sprite.flip_h = true


func set_flip_angle(angle: float) -> void:

	if angle > -90.0 or angle < 90.0:
		sprite.flip_h = false
	if angle < -90.0 or angle > 90.0:
		sprite.flip_h = true


func follow_mouse() -> void:
	look_at(get_global_mouse_position())
	set_flip_angle(mouse_angle)
