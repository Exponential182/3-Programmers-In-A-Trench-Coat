extends Node

@onready var main_menu = $"CanvasLayer/Main Menu"
@onready var world = $World
@onready var ip_entry = $"CanvasLayer/Main Menu/MarginContainer/VBoxContainer/IPEntry"

const Player = preload("res://prefabs/player.tscn")
const PORT = 53431
var enet_peer = ENetMultiplayerPeer.new() 



func _on_host_button_pressed() -> void:
	main_menu.hide()
	world.show()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	
	add_player(multiplayer.get_unique_id())


func _on_join_button_pressed() -> void:
	main_menu.hide()
	world.show()
	
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer


func add_player(peer_id):
	var player = Player.instantiate()
	player.position.y += 1
	player.name = str(peer_id)
	$World/Players.add_child(player)
