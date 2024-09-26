extends Control

@onready var hand_fire = $Hand_Fire

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand_fire.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
