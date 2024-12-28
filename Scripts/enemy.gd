extends CSGBox3D

@export var speed: float = 5.0 

var player: Node3D

func _ready():
	player = get_node_or_null("/Player")

func _physics_process(delta: float):
	if player:
		move_towards_player(delta)

func move_towards_player(delta: float):
	
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
