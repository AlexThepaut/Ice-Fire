extends Node3D

@export var HEAL_VALUE = 5

@onready var anim = $AnimatedSprite3D/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var anim_bounce = anim.get_animation("bounce")
	anim_bounce.loop_mode = (Animation.LOOP_LINEAR)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player") and body.HEALTH < body.MAX_HEALTH:
		body._heal(HEAL_VALUE)
		queue_free()
