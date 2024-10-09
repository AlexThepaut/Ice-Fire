extends Node3D
var speed = 12.0
var damage = 2.0

@onready var sprite = $Spell
@onready var ray = $Direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, -speed, 0) * delta
	if ray.is_colliding():
		ray.enabled = false
		speed = 0
		sprite.visible = false
		if ray.get_collider().is_in_group("Player"):
			ray.get_collider()._hit(damage)
		
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
