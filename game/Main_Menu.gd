extends Control

@onready var start_button = $Start
@onready var exit_button = $Quit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	start_button.set_size(Vector2(400, 100))
	exit_button.set_size(Vector2(400, 100))
	start_button.position.x = (get_viewport().size.x / 2) - 200
	start_button.position.y = get_viewport().size.y / 2 - 175
	exit_button.position.x = (get_viewport().size.x / 2) - 200
	exit_button.position.y = get_viewport().size.y / 2 + 25
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
