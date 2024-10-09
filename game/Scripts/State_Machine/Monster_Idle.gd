extends State
class_name MonsterIdle

@export var monster: CharacterBody3D
@export var move_speed := 2.0

var move_direction: Vector2
var wander_time: float
var wait_time: float

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	wander_time = randf_range(1, 3)
	wait_time = randf_range(3, 5)

func Enter():
	randomize_wander()

func Update(delta: float):
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
			monster.velocity = Vector3(move_direction.x, 0, move_direction.y) * move_speed
		else:
			monster.velocity = Vector3.ZERO
