extends Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../HelmetLight".rotation = rotation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$"../HelmetLight".rotation = rotation