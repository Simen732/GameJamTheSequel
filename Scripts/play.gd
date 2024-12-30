extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var control: Control = $Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_death_barrier_area_entered(area: Area3D) -> void:
	print("Du døde")
	animation_player.play("Death")
