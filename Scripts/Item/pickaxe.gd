extends Node3D

@onready var node_3d: Node3D = $"."
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pickaxe_area: Area3D = $PickaxeArea
@onready var pickaxe_collision: CollisionShape3D = $PickaxeArea/PickaxeCollision

signal PickaxeBonk
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	node_3d.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and Global.unlocks.pickaxe:
		node_3d.visible = true
		animation_player.play("bonk")
		
func _on_pickaxe_area_area_entered(area):
	Global.emit_signal("PickaxeDamageWall", area)
	#print(area)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	node_3d.visible = false
