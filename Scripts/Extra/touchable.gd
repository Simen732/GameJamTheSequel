extends Area3D

@onready var cool_view: Control = $CoolView
@onready var timer: Timer = $CoolView/Timer
@onready var animation_player: AnimationPlayer = $CoolView/AnimationPlayer

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
	animation_player.play("fade")
