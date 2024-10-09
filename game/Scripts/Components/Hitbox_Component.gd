extends Area3D
class_name HitboxComponent

@export var health_component: HealthComponent

func hit(attack: Attack):
	if health_component:
		health_component.damage(attack)
