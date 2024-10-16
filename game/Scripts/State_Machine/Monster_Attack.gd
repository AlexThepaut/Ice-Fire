extends State
class_name MonsterAttack

@export_group("General")
@export var monster: Monster
@export var nav_agent: NavigationAgent3D

@export_subgroup("Melee", "melee_")
@export var melee_cooldown: float
@export_range(0, 100, 0.1) var melee_cooldown_range: float

var player: Player
var wait_melee: float

func Enter() -> void:
	player = get_tree().get_first_node_in_group("Player")

func Update(delta: float) -> void:
	nav_agent.set_target_position(player.global_transform.origin)

	if nav_agent.distance_to_target() > monster.view_distance:
		Transitioned.emit(self, "monster_idle")

func randomize_melee_cooldown() -> void:
	var delta = (melee_cooldown * melee_cooldown_range) / 100
	wait_melee = randf_range(melee_cooldown - delta, melee_cooldown + delta)
