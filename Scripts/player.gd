extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const LOOK_SENSITIVITY = 0.1
const LOOK_LIMIT_UP = -120
const LOOK_LIMIT_DOWN = 80

@onready var pickaxe: Node3D = $Camera3D/Pickaxe
@onready var camera = $Camera3D
@onready var walk: AudioStreamPlayer3D = $Walk

var dashSpeed = 5
var jumpCount = 2
var pitch: float = 0.0  
var dashing = false
var dashDuration = 0.5 
var dashTimer = 0.0  
var TeleportRange = 15

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.openMenu.connect(_on_menu_opened)
	Global.closeMenu.connect(_on_menu_closed)
	
func _input(event):
	if event is InputEventMouseMotion and !Global.menu_open:
		rotate_y(deg_to_rad(-event.relative.x * LOOK_SENSITIVITY))
		
		pitch -= deg_to_rad(event.relative.y * LOOK_SENSITIVITY)
		pitch = clamp(pitch, deg_to_rad(LOOK_LIMIT_UP), deg_to_rad(LOOK_LIMIT_DOWN))
		camera.rotation.x = pitch 
		camera.rotation.z = 0
		
func _physics_process(delta: float) -> void:
	# Get movement input and handle player movement
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		walk.play()

	# Add gravity if not on the floor
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor():
		jumpCount = 2

	# Handle jump
	if Input.is_action_just_pressed("Jump") and jumpCount > 0:
		jumpCount -= 1
		velocity.y = JUMP_VELOCITY
		print("Denne funker")
	
	# Handle Dash
	if Input.is_action_just_pressed("Dash") and !dashing:
		dashing = true
		dashTimer = dashDuration/2  # Reset dash timer to start the dash
		
	# If dashing, apply dash speed
	if direction and dashing:
		velocity.x = direction.x * SPEED * dashSpeed
		velocity.z = direction.z * SPEED * dashSpeed
	else:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if(is_on_wall() and Global.unlocks.wallrun and Input.is_anything_pressed() ):
			jumpCount = 2
			velocity.y = 0
		
		# Handle Teleport
		if Input.is_action_just_pressed("Teleport") and Global.unlocks.teleport:
			# Get the direction the player is looking at
			var teleport_direction = camera.global_transform.basis.z.normalized()
			
			# Create a raycast to check for obstacles
			var space_state = get_world_3d().direct_space_state
			var ray_start = global_transform.origin
			var ray_end = ray_start - teleport_direction * TeleportRange
			
			# Create raycast query
			var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end)
			var result = space_state.intersect_ray(query)
			
			# If we hit something, teleport to just before the hit point
			if result:
				var distance_to_wall = ray_start.distance_to(result.position)
				global_transform.origin += -teleport_direction * (distance_to_wall - 3.0) # Subtract 1.0 to stop slightly before the wall
			else:
				# No wall found, teleport the full range
				global_transform.origin += -teleport_direction * TeleportRange
			
	if dashing:
		dashTimer -= delta
		if dashTimer <= 0.0:
			dashing = false  
			
	move_and_slide()

func _on_menu_opened() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_menu_closed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.get_parent().name == "PickaxeUnlock":
		print("Du har nå pickaxe")
		Global.emit_signal("PickaxeUnlocked")
		Global.unlocks.pickaxe = true
		area.get_parent().queue_free()
		
	if area.get_parent().name == "TeleportUnlock":
		print("Du har nå TeleportUnlock")
		Global.emit_signal("TeleportUnlocked")
		Global.unlocks.teleport = true
		area.get_parent().queue_free()
		
	if area.get_parent().name == "WallrunUnlock":
		print("Du har nå WallRunningUnlock")
		Global.unlocks.wallrun = true
		area.get_parent().queue_free()
		
	if area.get_parent().name == "GrapplingHookUnlock":
		print("Du har nå GraplingHookUnlock")
		Global.emit_signal("GrappleUnlocked")
		Global.unlocks.grapplingHook = true
		area.get_parent().queue_free()
		
	if area.get_parent().name == "BrushUnlock":
		print("Du har nå Brush")
		Global.emit_signal("BrushUnlocked")
		Global.unlocks.brush = true
		area.get_parent().queue_free()

	if area.get_parent().name == "LightUnlock":
		print("Du har nå Light")
		Global.emit_signal("LightUnlocked")
		Global.unlocks.light = true
		area.get_parent().queue_free()
