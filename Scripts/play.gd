extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody3D = $Player
@onready var original_spawn: CollisionShape3D = $Area3D/OriginalSpawn
@onready var kreft: CollisionShape3D = $Area3D2/kreft
@onready var kreft_2: CollisionShape3D = $Area3D3/kreft2
@onready var kreft_3: CollisionShape3D = $Area3D4/kreft3
@onready var kreft_4: CollisionShape3D = $Area3D5/kreft4

@onready var control: Control = $Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.playerDead.connect(on_playerDead)
	$MapGameJam/Cylinder.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_death_barrier_area_entered(area: Area3D) -> void:
	print("Du døde")
	animation_player.play("Death")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Global.emit_signal("playerDead")

func on_playerDead():
	if Global.stages.pyramid == true:
		player.global_position = kreft.global_position
	elif Global.stages.room1 == true:
		player.global_position = kreft_2.global_position
	elif Global.stages.room2 == true:
		player.global_position = kreft_3.global_position
	elif Global.stages.boss == true:
		player.global_position = kreft_4.global_position
	else:
		player.global_position = original_spawn.global_position


func _on_area_3d_3_area_entered(area: Area3D) -> void:
	Global.stages.room1 = true
	Global.stages.pyramid = false
	print(Global.stages)


func _on_area_3d_4_area_entered(area: Area3D) -> void:
	Global.stages.room2 = true
	Global.stages.pyramid = false
	Global.stages.room1 = false
	print(Global.stages)


func _on_area_3d_5_area_entered(area: Area3D) -> void:
	Global.stages.boss = true
	Global.stages.pyramid = false
	Global.stages.room1 = false
	Global.stages.room2 = false
	print(Global.stages)
