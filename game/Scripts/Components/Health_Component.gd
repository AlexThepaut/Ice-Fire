extends Node3D
class_name HealthComponent

var health: float
@export var MAX_HEALTH: float

func _ready() -> void:
	health = MAX_HEALTH

func damage(attack: Attack) -> void:
	health -= attack.damage

func heal(heal) -> void:
	health += heal
	if health > MAX_HEALTH:
		health = MAX_HEALTH
