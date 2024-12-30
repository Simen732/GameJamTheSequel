extends CharacterBody3D

@export var speed: float = 2.0 
var enemyHealth = 4
@onready var hitbox_area: Area3D = $hitboxArea
@onready var animation_player: AnimationPlayer = $"Root Scene/AnimationPlayer"
@export var detection_range: float = 5.0  # Adjust this value for the range within which the enemy moves towards the player
var player: Node3D

func _ready():
	player = get_node_or_null("../Player")
	Global.PickaxeDamageWall.connect(on_PickaxeDamageWall)

func _physics_process(delta: float):
	if player:
		move_towards_player(delta)

func move_towards_player(delta: float):
	var direction = (player.global_transform.origin - global_transform.origin).normalized()
	var distance_to_player = global_transform.origin.distance_to(player.global_transform.origin)
	# Move only if within detection range
	if distance_to_player <= detection_range:
		translate(direction * speed * delta)
	
func on_PickaxeDamageWall(area) -> void:
	if area == self.hitbox_area:
		enemyHealth -= 1
		print(enemyHealth, area)
		print(enemyHealth < 1)
		if enemyHealth < 1:
			animation_player.play("SpiderArmature|Spider_Death")
			print(hitbox_area.get_parent())


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	hitbox_area.get_parent().queue_free()
