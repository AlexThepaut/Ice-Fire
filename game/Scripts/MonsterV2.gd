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
@onready var hand_ray = $RayCast3D

var player = null
var player_distance = 9999.0

var spell_path = load("res://Scenes/Spell/Monster_Spell.tscn")
var instance

enum STATE {
	IDLE,
	FLY,
	SHOOT
}

var previous_state = STATE.IDLE
var actual_state = STATE.IDLE

var is_shooting = false

func _ready() -> void:
	player = get_node(player_path)

func _process(delta: float) -> void:
	# Add the gravity.
	if HEALTH > 0:
		if not is_on_floor():
			velocity += get_gravity() * delta

		match actual_state:
				STATE.IDLE:
					idle()
				STATE.FLY:
					fly()
				STATE.SHOOT:
					shoot()

		move_and_slide()

func _hit(dam):
	actual_state = STATE.FLY
	HEALTH -= dam
	if HEALTH <= 0:
		collision.disabled = true
		anim.play("Death")
		await anim.animation_looped
		queue_free()

func idle() -> void:
	velocity = Vector3.ZERO
	anim.play("Idle")

func fly() -> void:
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	player_distance = nav_agent.distance_to_target()
	var next_nav_point = nav_agent.get_next_path_position()
	
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	anim.play("Fly")
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)

func shoot() -> void:
	print("shoot")
	is_shooting = true
	velocity = Vector3.ZERO
	anim.play("Shoot")
	await anim.animation_looped
	anim.stop()
	instance = spell_path.instantiate()
	instance.position = hand_ray.global_position
	instance.transform.basis = hand_ray.global_transform.basis
	get_parent().add_child(instance)
	actual_state = previous_state
	is_shooting = false

func _on_sight_range_body_entered(body: Node3D) -> void:
	if not is_shooting:
		actual_state = STATE.FLY

func _on_sight_range_body_exited(body: Node3D) -> void:
	print(is_shooting, actual_state)
	if not is_shooting:
		actual_state = STATE.IDLE

func _on_timer_timeout() -> void:
	print(player_distance, FIRE_DISTANCE)
	if player_distance < FIRE_DISTANCE:
		previous_state = actual_state
		actual_state = STATE.SHOOT
