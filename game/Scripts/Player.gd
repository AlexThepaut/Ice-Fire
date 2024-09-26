extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.005

const BOB_FREQ = 2.0
const BOB_AMP = 0.08

var t_bob = 0.0
var gravity = 9.8

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var hand_animation = $Head/Camera3D/Hand/RootNode/AnimationPlayer
@onready var hand_ray = $Head/Camera3D/Hand/RootNode/RayCast3D

var fire_ball = load("res://Scenes/Fire.tscn")
var instance

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(80))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Strife_Left", "Strife_Right", "Forward", "Backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 5.0)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 5.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 2.0)

	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	if Input.is_action_just_pressed("Fire"):
			if !hand_animation.is_playing():
				hand_animation.play("Fire")
				instance = fire_ball.instantiate()
				instance.position = hand_ray.global_position
				instance.transform.basis = hand_ray.global_transform.basis
				get_parent().add_child(instance)

	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
