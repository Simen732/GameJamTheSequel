extends Control

func _ready() -> void:
	Global.openMenu.connect(_on_menu_opened)
	Global.closeMenu.connect(_on_menu_closed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		Global.toggle_menu()

func _on_menu_opened() -> void:
	$EscButtons.visible = true
	$TextureRect.visible = false

func _on_menu_closed() -> void:
	$EscButtons.visible = false
	$TextureRect.visible = true

func _on_continue_pressed() -> void:
	Global.toggle_menu()

func _on_exit_pressed() -> void:
	get_tree().quit()
