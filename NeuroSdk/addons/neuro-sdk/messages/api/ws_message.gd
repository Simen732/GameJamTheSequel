class_name WsMessage

var command: String
var data
var game: String

func _init(command_: String, data_, game_: String):
	command = command_
	data = data_
	game = game_

func get_data() -> Dictionary:
	return {
		"command": command,
		"game": game,
		"data": data
	}
