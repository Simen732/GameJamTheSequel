extends Node

signal PickaxeDamageWall
signal PickaxeUnlocked

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
