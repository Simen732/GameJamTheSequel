@tool
extends EditorPlugin


# this could probably be more descriptive, along with the singleton itself.
const AUTOLOAD_NAME: String = "neuro_sdk"


func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/neuro-sdk/neuro_sdk.tscn")


func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)
