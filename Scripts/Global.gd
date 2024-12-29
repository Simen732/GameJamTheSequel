extends Node

signal PickaxeDamageWall
signal PickaxeUnlocked
signal brushBrushingObject

signal BrushUnlocked
signal TeleportUnlocked
signal GrappleUnlocked
signal LightUnlocked

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
	"room3": false,
	"boss": false
}
