extends CharacterBody3D
class_name Player

@onready var head = $Head
@onready var camera = $Head/Camera
@onready var hand_ray = $Head/Camera/Fire_Ray
@onready var center_ray = $Head/Camera/Visor_Ray
@onready var gui = $Head/Camera/GUI
@onready var timer = $Damage_Timer

@export var MAX_HEALTH = 10
@export var HEALTH = MAX_HEALTH

const SPEED = 4.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.005
const BOB_FREQ = 3.5
const BOB_AMP = 0.06
const GRAVITY = 9.8

var t_bob = 0.0
var fire_ball = load("res://Scenes/Spell/Fire.tscn")
var instance
var hitable = true

func _ready() -> void:
	gui.get_node("Health_Bar").max_value = MAX_HEALTH
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(80))

func _physics_process(delta: float) -> void:
	# Add the GRAVITY.
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

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
			velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 3.0)
			velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 3.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 1.5)
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 1.5)

	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	if Input.is_action_just_pressed("Fire"):
			#if !hand_animation.is_playing():
				#hand_animation.play("Fire")
		instance = fire_ball.instantiate()
		instance.position = hand_ray.global_position
		instance.transform.basis = hand_ray.global_transform.basis
		get_parent().add_child(instance)

	move_and_slide()

func _process(delta: float) -> void:
	gui.get_node("Health_Bar").value = HEALTH
	
	if center_ray.is_colliding() and center_ray.get_collider().is_in_group("Monsters"):
		gui.get_node("Monster_Bar").visible = true
		gui.get_node("Monster_Bar").get_node("Monster_Label").visible = true
		gui.get_node("Monster_Bar").max_value = center_ray.get_collider().health_component.MAX_HEALTH
		gui.get_node("Monster_Bar").value = center_ray.get_collider().health_component.health
		gui.get_node("Monster_Bar").get_node("Monster_Label").text = center_ray.get_collider().name
	else: 
		gui.get_node("Monster_Bar").visible = false
		gui.get_node("Monster_Bar").get_node("Monster_Label").visible = false

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func _hit(damage) -> void:
	if hitable:
		hitable = false
		timer.start(0.1)
		HEALTH -= damage
		
		if HEALTH <= 0:
			get_tree().change_scene_to_file("res://Scenes/Main_menu.tscn")

func _heal(heal) -> void:
	HEALTH += heal
	if HEALTH > MAX_HEALTH:
		HEALTH = MAX_HEALTH

func _on_timer_timeout() -> void:
	hitable = true
