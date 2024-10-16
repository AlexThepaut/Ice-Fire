extends RigidBody3D
class_name Spell

@export var type: SpellConstant.Type
@export var speed = 20.0
@export var damage = 4.0
@export var ray: RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, speed, 0) * delta
	if ray.is_colliding():
		speed = 0
		ray.enabled = false
		print(ray.get_collider())
		if ray.get_collider() is HitboxComponent:
			ray.get_collider().hit(Attack.create(damage, type))
		
		await get_tree().create_timer(0.4).timeout
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
