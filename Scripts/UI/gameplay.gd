extends Control
@onready var controls_list: VBoxContainer = $ControlsList
@onready var controls: Label = $Controls

func _ready() -> void:
	$ControlsList.visible = false
	$ControlsList/Brush.visible = false
	$ControlsList/Pickaxe.visible = false
	$ControlsList/Light.visible = false
	$ControlsList/Teleport.visible = false
	$"ControlsList/Grappling Hook".visible = false
	
	# Correct signal connection syntax
	Global.BrushUnlocked.connect(func(): enableControlListItem("brush"))
	Global.PickaxeUnlocked.connect(func(): enableControlListItem("pickaxe"))
	Global.LightUnlocked.connect(func(): enableControlListItem("light"))
	Global.TeleportUnlocked.connect(func(): enableControlListItem("teleport"))
	Global.GrappleUnlocked.connect(func(): enableControlListItem("grapple"))

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("OpenControls"):
		$ControlsList.visible = !$ControlsList.visible

func enableControlListItem(item: String):
	if item == "brush":
		$ControlsList/Brush.visible = true
	elif item == "pickaxe":
		$ControlsList/Pickaxe.visible = true
	elif item == "light":
		$ControlsList/Light.visible = true
	elif item == "teleport":
		$ControlsList/Teleport.visible = true
	elif item == "grapple":
		$"ControlsList/Grappling Hook".visible = true
