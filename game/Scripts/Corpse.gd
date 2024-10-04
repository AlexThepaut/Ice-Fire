extends CharacterBody3D

@onready var anim = $AnimatedSprite3D

var gravity = 9.8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play()
	await anim.animation_looped
	anim.stop()
	anim.set_frame_and_progress(29, 0.0)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()
