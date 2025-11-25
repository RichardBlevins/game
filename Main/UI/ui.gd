extends CanvasLayer

@onready var main_menu = $MainMenu
@onready var address_entry = $MainMenu/MarginContainer/VBoxContainer/Address

const Player = preload("res://Main/Player/Player.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_text_delete"):
		get_tree().quit() 

func _on_host_pressed() -> void:
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())

func _on_join_pressed() -> void:
	main_menu.hide()
	
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	add_player(multiplayer.get_unique_id())

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)
