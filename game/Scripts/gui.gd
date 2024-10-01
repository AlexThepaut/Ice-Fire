extends Control

@onready var hand_fire = $Hand_Fire
@onready var crosshair = $Crosshair

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand_fire.play()
	crosshair.position.x = get_viewport().size.x / 2
	crosshair.position.y = get_viewport().size.y / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
