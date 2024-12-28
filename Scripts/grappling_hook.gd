extends Node3D

var target_pos: Vector3
var going_to_target := false
var going_to_parent := false
@export var hook_speed := 20.0

func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Grapple"):
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
		global_position = global_position.move_toward(target_pos, hook_speed * delta)
	elif going_to_parent:
		global_position = global_position.move_toward(get_parent().global_position, hook_speed * delta)
		if global_position == get_parent().global_position:
			going_to_parent = false
			visible = false
