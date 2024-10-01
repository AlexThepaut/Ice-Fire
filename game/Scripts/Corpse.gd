extends Node3D

@onready var anim = $AnimatedSprite3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play()
	await anim.animation_looped
	anim.stop()
	anim.set_frame_and_progress(29, 0.0)
