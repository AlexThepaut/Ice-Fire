class_name Attack

var damage: float

static func create(damage: float) -> Attack:
	var attack = Attack.new()
	attack.damage = damage
	return attack
