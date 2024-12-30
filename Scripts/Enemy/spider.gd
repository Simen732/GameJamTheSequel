extends CharacterBody3D

const SPEED = 2.5
const JUMP_VELOCITY = 4.5
const DETECTION_RANGE = 30.0
const ROTATION_SPEED = 10.0  # Adjust this to control turning speed
const ATTACK_RANGE = 3  # Distance at which the spider stops and attacks

@onready var animation_player2: AnimationPlayer = $SpiderAttackArea/AnimationPlayer
@onready var animation_player: AnimationPlayer = $SpiderModel/AnimationPlayer
var player: Node3D = null
var is_attacking: bool = false

func _ready() -> void:
	player = $"../Player"
	if not player:
		push_warning("Player node not found!")

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if not player:
		return
		
	# Check if player is within range and line of sight
	var distance_to_player = global_position.distance_to(player.global_position)
	
	if distance_to_player > DETECTION_RANGE or not has_line_of_sight():
		# Player out of range or sight, stop moving
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		play_animation("SpiderArmature|Spider_Idle")
		is_attacking = false
		return
		
	# Get direction to player
	var direction = (player.global_position - global_position)
	direction.y = 0  # Keep movement on the horizontal plane
	direction = direction.normalized()
	
	# Rotate to face player
	if direction:
		var target_rotation = atan2(direction.x, direction.z)
		var current_rotation = rotation.y
		
		# Smoothly interpolate the rotation
		rotation.y = lerp_angle(current_rotation, target_rotation, delta * ROTATION_SPEED)
	
	# Check if within attack range
	if distance_to_player <= ATTACK_RANGE:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if not is_attacking:
			is_attacking = true
			play_animation("SpiderArmature|Spider_Attack")
			animation_player2.play("attack")
		return
	
	# If not attacking and no floor ahead, stop
	if not check_floor_ahead(direction):
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		play_animation("SpiderArmature|Spider_Idle")
		return
	
	# Move towards player if not in attack range
	is_attacking = false
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	play_animation("SpiderArmature|Spider_Walk")
	
	move_and_slide()

func has_line_of_sight() -> bool:
	if not player:
		return false
		
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		global_position,
		player.global_position
	)
	# Ignore self
	query.exclude = [self]
	
	var result = space_state.intersect_ray(query)
	if result.is_empty():
		return true
		
	# Check if the first object hit is the player
	return result.collider == player

func check_floor_ahead(direction: Vector3) -> bool:
	var space_state = get_world_3d().direct_space_state
	
	# Cast ray downward from a point slightly ahead
	var ahead_position = global_position + direction * 2.0
	var ray_start = ahead_position + Vector3.UP
	var ray_end = ahead_position + Vector3.DOWN * 2.0
	
	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end)
	query.exclude = [self]
	
	var result = space_state.intersect_ray(query)
	return not result.is_empty()

func play_animation(anim_name: String) -> void:
	if animation_player.current_animation != anim_name:
		animation_player.play(anim_name)

func _on_spider_attack_area_area_entered(area: Area3D) -> void:
	print("Hit something")
	print(area)
	print(area.get_parent())
	if area.get_parent() == player:
		Global.PlayerHP -= 1
		print(Global.PlayerHP)
		if Global.PlayerHP < 1:
			Global.PlayerHP = 5
			Global.emit_signal("playerDead")
