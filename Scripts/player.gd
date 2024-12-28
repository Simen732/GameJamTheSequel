extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const LOOK_SENSITIVITY = 0.1
const LOOK_LIMIT_UP = -120
const LOOK_LIMIT_DOWN = 80

@onready var pickaxe: Node3D = $Camera3D/Pickaxe
@onready var camera = $Camera3D

var dashSpeed = 5
var jumpCount = 2
var Menu_open = false
var pitch: float = 0.0  
var dashing = false
var dashDuration = 0.5 
var dashTimer = 0.0  
var TeleportRange = 20



func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
	
func _input(event):
	if event is InputEventMouseMotion and !Menu_open:
		rotate_y(deg_to_rad(-event.relative.x * LOOK_SENSITIVITY))
		
		pitch -= deg_to_rad(event.relative.y * LOOK_SENSITIVITY)
		pitch = clamp(pitch, deg_to_rad(LOOK_LIMIT_UP), deg_to_rad(LOOK_LIMIT_DOWN))
		camera.rotation.x = pitch 
		camera.rotation.z = 0
		
func _physics_process(delta: float) -> void:
	# Get movement input and handle player movement
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Add gravity if not on the floor
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor():
		jumpCount = 2

	if Input.is_action_just_pressed("escape"):
		if Menu_open == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
			Menu_open = true
			print("Den er open")
		else: 
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) 
			Menu_open = false
			print("Den er lukket")
			
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
		if(is_on_wall() ):
			jumpCount = 2
			velocity.y = 0
		
		# Handle Teleport
		if Input.is_action_just_pressed("Teleport"):
			# Get the direction the player is looking at
			var teleport_direction = camera.global_transform.basis.z.normalized()
			# Apply the teleport, scaling by the teleport range
			global_transform.origin += -teleport_direction * TeleportRange
			
	# Handle dash timer countdown
	if dashing:
		dashTimer -= delta
		if dashTimer <= 0.0:
			dashing = false  # End the dash when timer runs out
			
	move_and_slide()
