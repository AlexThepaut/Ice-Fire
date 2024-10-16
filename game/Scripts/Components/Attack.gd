class_name Attack

var damage: float
var type: SpellConstant.Type

static func create(damage: float, type: SpellConstant.Type) -> Attack:
	var attack = Attack.new()
	attack.damage = damage
	attack.type = type
	return attack
