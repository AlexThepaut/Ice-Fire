extends State
class_name MonsterShoot

@export_group("General")
@export var monster: Monster
@export var nav_agent: NavigationAgent3D

@export_subgroup("Distance", "distance_")
@export_file("*.tscn") var distance_spell_path: String
@export var distance_spell_origin: RayCast3D
@export var distance_range := 10.0
@export var distance_cooldown: float
@export_range(0, 100, 0.1) var distance_cooldown_range: float

var player: Player
var is_shooting: bool
var cooldown = 0.0

func Enter() -> void:
	player = get_tree().get_first_node_in_group("Player")

func Update(delta: float) -> void:
	nav_agent.set_target_position(player.global_transform.origin)

	if cooldown < 0:
		monster.is_shooting = true
		monster.velocity = Vector3.ZERO
		var instance = load(distance_spell_path).instantiate()
		instance.position = distance_spell_origin.global_position + Vector3(0, 0.5, 0)
		instance.transform.basis = distance_spell_origin.global_transform.basis
		get_tree().get_first_node_in_group("World").add_child(instance)
		randomize_distance_cooldown()
		await get_tree().create_timer(0.5).timeout
		monster.is_shooting = false
	else:
		cooldown -= delta

	if nav_agent.distance_to_target() > monster.view_distance:
		Transitioned.emit(self, "monster_idle")

func Physics_Update(delta: float) -> void:
	monster.look_at(Vector3(player.global_position.x, monster.global_position.y, player.global_position.z), Vector3.UP)

func randomize_distance_cooldown() -> void:
	var delta = (distance_cooldown * distance_cooldown_range) / 100
	cooldown = randf_range(distance_cooldown - delta, distance_cooldown + delta)
