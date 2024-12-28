extends CSGBox3D
@onready var breakable_wall: CSGBox3D = $"."
@onready var breakable_wall_area: Area3D = $BreakableWallArea

var wallHealth = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.PickaxeDamageWall.connect(on_PickaxeDamageWall)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func on_PickaxeDamageWall(area) -> void:
	if area == self.breakable_wall_area:
		wallHealth -= 1
		print(wallHealth, area)
		if wallHealth < 1:
			queue_free()
