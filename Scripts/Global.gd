extends Node

signal PickaxeDamageWall
signal PickaxeUnlocked
signal brushBrushingObject

signal BrushUnlocked
signal TeleportUnlocked
signal GrappleUnlocked
signal LightUnlocked

signal openMenu
signal closeMenu
var menu_open := false

var unlocks := {
	"wallrun": false,
	"grapplingHook": false,
	"teleport": false,
	"light": false,
	"pickaxe": false,
	"brush": false
}


var stages := {
	"pyramid": false,
	"room1": false,
	"room2": false,
	"boss": false
}

func toggle_menu():
	menu_open = !menu_open
	if menu_open:
		emit_signal("openMenu")
	else:
		emit_signal("closeMenu")
