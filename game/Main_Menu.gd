extends Control

@onready var start_button = $Start

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	start_button.set_size(Vector2(400, 100))
	print(get_viewport().size.x, start_button.get_viewport_rect().size.x)
	start_button.position.x = (get_viewport().size.x / 2) - 200
	start_button.position.y = get_viewport().size.y / 2 - 50
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
