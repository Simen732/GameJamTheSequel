extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pickaxe_area: Area3D = $PickaxeArea
@onready var pickaxe_collision: CollisionShape3D = $PickaxeArea/PickaxeCollision

signal PickaxeBonk
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		animation_player.play("bonk")
		
		
		

func _on_pickaxe_area_area_entered(area: Area3D) -> void:
	emit_signal("PickaxeBonk")
	print(area)
