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
	var arrayOfHearts = [$HeartContainer/Heart, $HeartContainer/Heart2, $HeartContainer/Heart3, $HeartContainer/Heart4, $HeartContainer/Heart5]
	# Loop through each heart and update its texture based on player HP
	for i in range(arrayOfHearts.size()):
		if i < Global.PlayerHP:
			# Show filled heart if index is less than current HP
			arrayOfHearts[i].texture = load("res://Assets/Images/HeartFilled.png")
		else:
			# Show empty heart if index is greater than or equal to current HP
			arrayOfHearts[i].texture = load("res://Assets/Images/HeartEmpty.png")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("openControls"):
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
