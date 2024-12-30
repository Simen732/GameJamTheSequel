extends CharacterBody3D

const SPEED = 2.5
const JUMP_VELOCITY = 4.5
const DETECTION_RANGE = 30.0
const ROTATION_SPEED = 10.0
const ATTACK_RANGE = 3.0
const ATTACK_COOLDOWN = 0.5

@onready var animation_player2: AnimationPlayer = $NeuroAttackArea/AnimationPlayer
@onready var animation_player: AnimationPlayer = $WaifuBoss2/AnimationPlayer

var player: Node3D = null
var is_attacking: bool = false
var can_attack: bool = true
var attack_timer: float = 0.0
var action_window: ActionWindow = null

class AttackAction extends NeuroAction:
	func _get_name() -> String:
		return "attack"
		
	func _get_description() -> String:
		return "Attack the player if they are in range"
		
	func _get_schema() -> Dictionary:
		return {}
		
	func _validate_action(_data: IncomingData, _state: Dictionary) -> ExecutionResult:
		var boss = self
		if not boss.can_attack:
			return ExecutionResult.failure("Cannot attack yet - on cooldown")
		if not boss.player:
			return ExecutionResult.failure("No player found to attack")
		if boss.global_position.distance_to(boss.player.global_position) > boss.ATTACK_RANGE:
			return ExecutionResult.failure("Player is too far away to attack")
		return ExecutionResult.success()
		
	func _execute_action(_state: Dictionary) -> void:
		var boss = self
		boss.start_attack()

class MoveToPlayerAction extends NeuroAction:
	func _get_name() -> String:
		return "move_to_player"
		
	func _get_description() -> String:
		return "Move closer to the player"
		
	func _get_schema() -> Dictionary:
		return {}
		
	func _validate_action(_data: IncomingData, _state: Dictionary) -> ExecutionResult:
		var boss = self
		if not boss.player:
			return ExecutionResult.failure("No player found to move to")
		if not boss.has_line_of_sight():
			return ExecutionResult.failure("No line of sight to player")
		if boss.global_position.distance_to(boss.player.global_position) <= boss.ATTACK_RANGE:
			return ExecutionResult.failure("Already in attack range")
		return ExecutionResult.success()
		
	func _execute_action(_state: Dictionary) -> void:
		pass

func _ready() -> void:
	player = $"../Player"
	if not player:
		push_warning("Player node not found!")
	
	if Global.IsConnected:
		setup_neuro_integration()

func setup_neuro_integration() -> void:
	# CHANGE THIS TO YOUR GAME NAME
	NeuroSdkConfig.game = "Your Game Name Here"
	
	action_window = ActionWindow.new(self)
	action_window.add_action(AttackAction.new(action_window))
	action_window.add_action(MoveToPlayerAction.new(action_window))
	action_window.set_force(5.0, "You are a boss fighting the player. Choose whether to attack or move closer.", "")
	action_window.register()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if not player:
		return
		
	if not can_attack:
		attack_timer += delta
		if attack_timer >= ATTACK_COOLDOWN:
			can_attack = true
			attack_timer = 0.0
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	if not Global.IsConnected:
		handle_default_ai(distance_to_player, delta)
	else:
		if distance_to_player > DETECTION_RANGE or not has_line_of_sight():
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			play_animation("Idle")
			return
			
		var direction = (player.global_position - global_position)
		direction.y = 0
		direction = direction.normalized()
		
		if direction:
			var target_rotation = atan2(direction.x, direction.z)
			var current_rotation = rotation.y
			rotation.y = lerp_angle(current_rotation, target_rotation, delta * ROTATION_SPEED)
		
		if not is_attacking and check_floor_ahead(direction):
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			play_animation("Move")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func handle_default_ai(distance_to_player: float, delta: float) -> void:
	if distance_to_player > DETECTION_RANGE or not has_line_of_sight():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		play_animation("Idle")
		is_attacking = false
		return
		
	var direction = (player.global_position - global_position)
	direction.y = 0
	direction = direction.normalized()
	
	if direction:
		var target_rotation = atan2(direction.x, direction.z)
		var current_rotation = rotation.y
		rotation.y = lerp_angle(current_rotation, target_rotation, delta * ROTATION_SPEED)
	
	if distance_to_player <= ATTACK_RANGE:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if can_attack and not is_attacking:
			start_attack()
		return
	
	if not check_floor_ahead(direction):
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		play_animation("Idle")
		return
	
	is_attacking = false
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	play_animation("Move")

func start_attack() -> void:
	is_attacking = true
	can_attack = false
	play_animation("Attack")
	animation_player2.play("attack")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Attack":
		is_attacking = false
		
		if player and global_position.distance_to(player.global_position) <= ATTACK_RANGE:
			if can_attack:
				start_attack()

func has_line_of_sight() -> bool:
	if not player:
		return false
		
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		global_position,
		player.global_position
	)
	query.exclude = [self]
	
	var result = space_state.intersect_ray(query)
	if result.is_empty():
		return true
		
	return result.collider == player

func check_floor_ahead(direction: Vector3) -> bool:
	var space_state = get_world_3d().direct_space_state
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

func _on_neuro_attack_area_area_entered(area: Area3D) -> void:
	if area.get_parent() == player:
		Global.PlayerHP -= 2
		print("Player HP: ", Global.PlayerHP)
		if Global.PlayerHP < 1:
			Global.PlayerHP = 5
			Global.emit_signal("playerDead")
