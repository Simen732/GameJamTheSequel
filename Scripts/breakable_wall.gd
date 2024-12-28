extends CSGBox3D
@onready var breakable_wall: CSGBox3D = $"."

var wallHealth = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_character_body_3d_damage_wall() -> void:
	wallHealth -= 1
	print(wallHealth)
	if wallHealth < 1:
		queue_free()
