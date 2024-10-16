extends State
class_name MonsterIdle

@export var monster: Monster
@export var nav_agent: NavigationAgent3D

var move_direction: Vector2

var player: Player

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	monster.velocity = Vector3.ZERO

func Update(delta: float):
	nav_agent.set_target_position(player.global_transform.origin)
	if nav_agent.distance_to_target() < monster.view_distance:
		Transitioned.emit(self, "monster_follow")
