extends State
class_name MonsterIdleWander

@export var monster: Monster
@export var nav_agent: NavigationAgent3D

var move_direction: Vector2
var wander_time: float
var wait_time: float

var player: Player

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	wander_time = randf_range(1, 3)
	wait_time = randf_range(3, 5)

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	randomize_wander()

func Update(delta: float):
	nav_agent.set_target_position(player.global_transform.origin)
	if nav_agent.distance_to_target() < monster.view_distance:
		Transitioned.emit(self, "monster_follow")
	
	if wander_time > 0:
		wander_time -= delta
	else:
		if wait_time > 0:
			wait_time -= delta
		else:
			randomize_wander()

func Physics_Update(delta: float):
	if monster: 
		if wander_time > 0:
			monster.velocity = Vector3(move_direction.x, 0, move_direction.y) * monster.move_speed
		else:
			monster.velocity = Vector3.ZERO
