extends Control
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/play.tscn")

func _on_options_button_pressed() -> void:
	pass

func _on_close_button_pressed() -> void:
	get_tree().quit()
