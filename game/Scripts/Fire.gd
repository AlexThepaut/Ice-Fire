extends Node3D

var speed = 20.0

@onready var sprite = $Flamme
@onready var ray = $RayCast3D
@onready var particules = $Sparkle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play()
	particules.visible = false;
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, -speed, 0) * delta
	if ray.is_colliding():
		speed = 0
		sprite.visible = false
		particules.play()
		
		particules.visible = true
		await get_tree().create_timer(0.4).timeout
		queue_free()

func _on_timer_timeout() -> void:
	queue_free()
