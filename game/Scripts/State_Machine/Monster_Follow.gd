extends State
class_name MonsterFollow

@export var monster: Monster
@export var nav_agent: NavigationAgent3D

var player: Player
var monster_distance: bool
var monster_melee: bool

func Enter() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
	monster_distance = get_parent().has_state("monster_shoot")
	monster_melee = get_parent().has_state("monster_attack")

func Update(delta: float) -> void:
	nav_agent.set_target_position(player.global_transform.origin)

	if nav_agent.distance_to_target() > monster.view_distance:
		Transitioned.emit(self, "monster_idle")

	if monster_melee:
		if nav_agent.distance_to_target() < 1:
			Transitioned.emit(self, "monster_attack")
	if monster_distance:
		if nav_agent.distance_to_target() < get_parent().states.get("monster_shoot").distance_range:
			Transitioned.emit(self, "monster_shoot")

func Physics_Update(delta: float) -> void:
	var next_nav_point = nav_agent.get_next_path_position()

	monster.velocity = (next_nav_point - monster.global_transform.origin).normalized() * monster.move_speed
	monster.look_at(Vector3(player.global_position.x, monster.global_position.y, player.global_position.z), Vector3.UP)
