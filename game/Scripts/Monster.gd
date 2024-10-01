extends CharacterBody3D

@export var HEALTH = 10
@export var SPEED = 2.0
@export var DETECTION_RADIUS = 20.0
@export var SHOOTING_RANGE = 5.0

@onready var anim = $AnimatedSprite3D
@onready var nav_agent = $NavigationAgent3D
@onready var collider = $CollisionShape3D

var player = null
var monster_state = null

@export var player_path: NodePath

var corpse = load("res://Scenes/Mobs/Corpse.tscn")

enum STATE {
	IDLE,
	FLY,
	DEATH
}

func _ready() -> void:
	anim.play("Idle")
	player = get_node(player_path)
	monster_state = STATE.IDLE
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func _process(delta: float) -> void:
	
	#print(nav_agent.distance_to_target())
	if HEALTH > 0:
		nav_agent.set_target_position(player.global_transform.origin)
		var next_nav_point = nav_agent.get_next_path_position()
		
		if nav_agent.distance_to_target() < DETECTION_RADIUS:
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))
			
			if nav_agent.distance_to_target() > SHOOTING_RANGE:
				velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
				monster_state = STATE.FLY
				
			else:
				velocity = Vector3.ZERO
				monster_state = STATE.IDLE
		else:
			velocity = Vector3.ZERO
			monster_state = STATE.IDLE
		_play_animation()
		move_and_slide()

func _play_animation() -> void:
	match monster_state:
		STATE.IDLE:
			anim.play("Idle")
		STATE.FLY:
			anim.play("Fly")


func _hit(dam):
	HEALTH -= dam
	if HEALTH <= 0:
		var instance = corpse.instantiate()
		instance.position = global_position
		get_parent().add_child(instance)
		anim.play("Death")
		await anim.animation_looped
		queue_free()
