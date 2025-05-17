class_name HurtboxComponent
extends Area2D


signal damage_taken


@export var health_component: HealthComponent = null


func _ready() -> void:
	assert(health_component, "A HealthComponent must be selected!")
	area_entered.connect(_on_area_entered)


func _on_area_entered(hitbox_component: HitboxComponent) -> void:
	health_component.health -= hitbox_component.damage
	damage_taken.emit()
