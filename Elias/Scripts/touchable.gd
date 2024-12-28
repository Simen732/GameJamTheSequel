extends Area3D
@onready var timer: Timer = $Timer
@onready var character_body_3d: CharacterBody3D = $"../CharacterBody3D"
@onready var timer_2: Timer = $Timer2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area3D) -> void:
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.start()


func _on_timer_timeout() -> void:
	character_body_3d.get_child(1).current = false
	$"../CoolIntermissionCamera/Camera3D".current = true
	$"../CoolIntermissionCamera/Camera3D/CoolThingy".visible = true
	timer_2.wait_time = 1.75
	timer_2.one_shot = true
	timer_2.start()


func _on_timer_2_timeout() -> void:
	$"../CoolIntermissionCamera/Camera3D".current = false
	character_body_3d.get_child(1).current = true
	$"../CoolIntermissionCamera/Camera3D/CoolThingy".visible = false
