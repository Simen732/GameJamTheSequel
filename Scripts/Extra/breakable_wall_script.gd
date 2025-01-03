extends Node

@onready var hitbox_area: Area3D = $"../hitboxArea"



var wallHealth = 5

func _ready() -> void:
	if hitbox_area.get_parent().get_meta("Hp"):
		wallHealth = hitbox_area.get_parent().get_meta("Hp")
	Global.PickaxeDamageWall.connect(on_PickaxeDamageWall)


func _process(delta: float) -> void:
	pass
	
	
func on_PickaxeDamageWall(area) -> void:
	if area == self.hitbox_area:
		wallHealth -= 1
		print(wallHealth, area)
		if wallHealth < 1:
			if self.get_parent().name == "NeuroBoss":
				get_tree().change_scene_to_file("res://CREDITS/GodotCredits.tscn")
			Global.PlayerHP = 5
			hitbox_area.get_parent().queue_free()
			print(hitbox_area.get_parent())
