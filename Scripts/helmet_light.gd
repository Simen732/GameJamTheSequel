extends SpotLight3D

var light_enabled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func _input(event):
	if event.is_action_pressed("right_click"):
		toggle_light()
		

func toggle_light():
	light_enabled = !light_enabled
	visible = light_enabled
