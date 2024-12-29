extends Node3D

var target_pos: Vector3
var going_to_target := false
var going_to_parent := false
var updateParentTicks := 10
var updateParentTotal := 0
@export var hook_speed := 20.0

func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Grapple") and Global.unlocks.grapplingHook:
		if not going_to_target and not going_to_parent:
			# First click - shoot to target
			var space_state = get_world_3d().direct_space_state
			var query = PhysicsRayQueryParameters3D.create(
				global_position, 
				global_position + -global_transform.basis.z * 20.0
			)
			var result = space_state.intersect_ray(query)
			
			if result:
				visible = true
				target_pos = result.position
				going_to_target = true
		
		elif going_to_target:
			# Second click - return to parent
			going_to_target = false
			going_to_parent = true

func _process(delta: float) -> void:
	if going_to_target:
		updateParentTotal -= 1
		global_position = global_position.move_toward(target_pos, hook_speed * delta)
	elif going_to_parent:
		visible = false
		var player = get_parent().get_parent()
		player.velocity = Vector3(0, 0, 0)
		player.global_position = player.global_position.move_toward(global_position, hook_speed * delta)
		updateParentTotal += 1
		if updateParentTicks < updateParentTotal:
			global_position = player.global_position
		if global_position == player.global_position:
			going_to_parent = false
