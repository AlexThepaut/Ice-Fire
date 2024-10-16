extends CharacterBody3D
class_name Monster

@export var move_speed := 2.0
@export var view_distance := 20.0
@export var is_flying := false
@export var health_component: HealthComponent
@export var animation_tree: AnimationTree

var is_shooting = false

func _ready() -> void:
	# Connecte le signal de changement d'état de l'AnimationTree
	animation_tree.get("parameters/playback").connect("changed", _on_state_changed)

func _physics_process(delta: float) -> void:
	if !is_flying:
		if not is_on_floor():
			velocity += get_gravity() * delta

	move_and_slide()

func _on_state_changed():
	var state_machine = animation_tree.get("parameters/playback")
	
	print(state_machine.current)
	if state_machine.current == "end":
		queue_free()
