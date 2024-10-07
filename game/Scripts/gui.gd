extends Control

@onready var hand_fire: AnimatedSprite2D = $Hand_Fire
@onready var crosshair = $Crosshair
@onready var monster_bar = $Monster_Bar
@onready var monster_label = $Monster_Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand_fire.play()
	crosshair.position.x = get_viewport().size.x / 2
	crosshair.position.y = get_viewport().size.y / 2
	hand_fire.position.x = get_viewport().size.x - hand_fire.sprite_frames.get_frame_texture("default", 0).get_width() * 2
	hand_fire.position.y = get_viewport().size.y - hand_fire.sprite_frames.get_frame_texture("default", 0).get_height() * 2
	monster_bar.position.x = get_viewport().size.x / 2 - monster_bar.get_under_texture().get_width() / 2

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
