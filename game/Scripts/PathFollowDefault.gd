extends PathFollow3D

const MOVE_SPEED = 2.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(progress_ratio, delta)
	progress_ratio += 0.04 * delta
	await get_tree().create_timer(5.0).timeout
