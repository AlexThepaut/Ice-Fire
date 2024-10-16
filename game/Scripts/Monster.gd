extends CharacterBody3D

@export var SPEED = 1.0
@export var DETECTION_DISTANCE = 20.0
@export var FIRE_DISTANCE = 10.0
@export var MAX_HEALTH = 10
@export var HEALTH = MAX_HEALTH
@export var PLAYER_PATH: NodePath

@onready var anim = $Sprites
@onready var nav_agent = $Navigation_Agent
@onready var collision = $Body_Collision
@onready var hand_ray = $Spell_Ray

enum STATE {
	IDLE,
	FLY,
	SHOOT
}

var previous_state = STATE.IDLE
var actual_state = STATE.IDLE
var is_shooting = false
var player: Player = null
var player_distance = 9999.0
var spell_path = load("res://Scenes/Spell/Monster_Spell.tscn")
var instance

func _ready() -> void:
	player = get_node(PLAYER_PATH)

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
	if not is_shooting:
		is_shooting = true
		velocity = Vector3.ZERO
		anim.play("Shoot")
		instance = spell_path.instantiate()
		instance.position = hand_ray.global_position
		instance.transform.basis = hand_ray.global_transform.basis
		get_parent().add_child(instance)
		
		await anim.animation_looped
		anim.stop()
		
		actual_state = previous_state
		is_shooting = false

func _on_sight_range_body_entered(body: Node3D) -> void:
	if not is_shooting:
		actual_state = STATE.FLY

func _on_sight_range_body_exited(body: Node3D) -> void:
	if not is_shooting:
		actual_state = STATE.IDLE

func _on_timer_timeout() -> void:
	if player_distance < FIRE_DISTANCE:
		previous_state = actual_state
		actual_state = STATE.SHOOT
