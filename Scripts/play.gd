extends Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody3D = $Player
@onready var pyramid_spawnpoint: Area3D = $"Pyramid Spawnpoint"
@onready var collision_shape_3d: CollisionShape3D = $room1SpawnPoint/CollisionShape3D
@onready var collision_shape_3d_2: CollisionShape3D = $Area3D/CollisionShape3D2
@onready var collision_shape_3d_3: CollisionShape3D = $Area3D2/CollisionShape3D3
@onready var bg_music: AudioStreamPlayer3D = $"BG-Music"

@onready var control: Control = $Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.playerDead.connect(on_playerDead)
	bg_music.play()
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
		player.global_position = pyramid_spawnpoint.global_position
	elif Global.stages.room1 == true:
		player.global_position = collision_shape_3d.global_position
	elif Global.stages.room2 == true:
		player.global_position = collision_shape_3d_2.global_position
	elif Global.stages.boss == true:
		player.global_position = collision_shape_3d_3.global_position

func _on_room_1_spawn_point_area_entered(area: Area3D) -> void:
	Global.stages.room1 = true
	Global.stages.pyramid = false
	print(Global.stages)


func _on_bg_music_finished() -> void:
	bg_music.play()
