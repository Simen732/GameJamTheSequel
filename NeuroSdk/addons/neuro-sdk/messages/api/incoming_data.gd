class_name IncomingData

var _data: Dictionary

func _init(data: Dictionary):
	_data = data

func get_string(name: String, default: String = "") -> String:
	var value = _data.get(name, default)
	if typeof(value) != TYPE_STRING:
		value = default
	return value

func get_object(name: String, default: Dictionary = {}) -> IncomingData:
	var value = _data.get(name, {})
	if typeof(value) != TYPE_DICTIONARY:
		value = default
	return IncomingData.new(value)
