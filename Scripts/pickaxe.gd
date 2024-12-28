extends Node3D

@onready var node_3d: Node3D = $"."
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pickaxe_area: Area3D = $PickaxeArea
@onready var pickaxe_collision: CollisionShape3D = $PickaxeArea/PickaxeCollision

signal PickaxeBonk
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.PickaxeUnlocked.connect(on_PickaxeUnlocked)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and Global.unlocks.pickaxe:
		animation_player.play("bonk")
		
		
		
		
func _on_pickaxe_area_area_entered(area):
	Global.emit_signal("PickaxeDamageWall", area)
	#print(area)

func on_PickaxeUnlocked():
	node_3d.visible = true
