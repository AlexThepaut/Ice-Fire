extends CharacterBody3D

@export var MAX_HEALTH = 10
@export var HEALTH = MAX_HEALTH
@export var player_path: NodePath
const SPEED = 2.0
const DETECTION_DISTANCE = 20.0
const FIRE_DISTANCE = 10.0

@onready var anim = $AnimatedSprite3D
@onready var nav_agent = $NavigationAgent3D
@onready var collision = $CollisionShape3D

var player = null

func _ready() -> void:
	anim.play("Idle")
	player = get_node(player_path)
	

func _process(delta: float) -> void:
	# Add the gravity.
	if HEALTH > 0:
		if not is_on_floor():
			velocity += get_gravity() * delta

		velocity = Vector3.ZERO
		nav_agent.set_target_position(player.global_transform.origin)
		var next_nav_point = nav_agent.get_next_path_position()
		
		if nav_agent.distance_to_target() < DETECTION_DISTANCE:
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			anim.play("Fly")
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		else:
			anim.play("Idle")

		move_and_slide()

func _hit(dam):
	HEALTH -= dam
	if HEALTH <= 0:
		collision.disabled = true
		anim.play("Death")
		await anim.animation_looped
		queue_free()
