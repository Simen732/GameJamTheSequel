extends Node3D

func _ready() -> void:
	visible = false

func _input(event):
	if event.is_action_pressed("Grapple"):
		visible = true
