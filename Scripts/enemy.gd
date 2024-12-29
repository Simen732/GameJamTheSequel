extends CSGBox3D

@export var speed: float = 3.0 
var enemyHealth = 5
@onready var hitbox_area: Area3D = $hitboxArea

var player: Node3D

func _ready():
	player = get_node_or_null("/Player")
	if hitbox_area.get_parent().get_meta("Hp"):
		enemyHealth = hitbox_area.get_parent().get_meta("Hp")
	Global.PickaxeDamageWall.connect(on_PickaxeDamageWall)

func _physics_process(delta: float):
	if player:
		move_towards_player(delta)

func move_towards_player(delta: float):
	
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)

func on_PickaxeDamageWall(area) -> void:
	if area == self.hitbox_area:
		enemyHealth -= 1
		print(enemyHealth, area)
		if enemyHealth < 1:
			hitbox_area.get_parent().queue_free()
			print(hitbox_area.get_parent())
