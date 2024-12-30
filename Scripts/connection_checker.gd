extends Node

func _ready() -> void:
	check_neuro_connection()

func check_neuro_connection() -> void:
	if not OS.get_environment("NEURO_SDK_WS_URL"):
		Global.IsConnected = false
		return
		
	var socket := WebSocketPeer.new()
	var err := socket.connect_to_url(OS.get_environment("NEURO_SDK_WS_URL"))
	
	if err != OK:
		Global.IsConnected = false
		return
		
	# Wait a bit to check connection
	await get_tree().create_timer(2.0).timeout
	
	var state := socket.get_ready_state()
	Global.IsConnected = (state == WebSocketPeer.STATE_OPEN)
	
	socket.close()
