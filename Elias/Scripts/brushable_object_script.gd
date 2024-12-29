extends Node

@onready var brushArea: Area3D = $"../brushArea"



var objectHealth = 2

func _ready() -> void:
	if brushArea.get_parent().get_meta("Hp"):
		objectHealth = brushArea.get_parent().get_meta("Hp")
	Global.brushBrushingObject.connect(on_BrushBrushingObject)


func _process(delta: float) -> void:
	pass
	
	
func on_BrushBrushingObject(area) -> void:
	if area == self.brushArea:
		objectHealth -= 1
		print(objectHealth, area)
		if objectHealth < 1:
			brushArea.get_parent().queue_free()
			print(brushArea.get_parent())
