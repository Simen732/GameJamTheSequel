extends Node3D

@onready var node_3d: Node3D = $"."
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var brush_area: Area3D = $BrushArea
@onready var brush_collision: CollisionShape3D = $BrushArea/BrushCollision


func _ready() -> void:
	node_3d.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("brush") and Global.unlocks.brush:
		node_3d.visible = true
		animation_player.play("Use")
		
func _on_brush_area_area_entered(area):
	Global.emit_signal("brushBrushingObject", area)
	#print(area)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	node_3d.visible = false
