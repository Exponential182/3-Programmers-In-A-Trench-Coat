extends Node

@onready var main_menu = $"CanvasLayer/Main Menu"
@onready var world = $World
@onready var ip_entry = $"CanvasLayer/Main Menu/MarginContainer/VBoxContainer/IPEntry"
@onready var username_entry = $"CanvasLayer/Main Menu/MarginContainer/VBoxContainer/Username"

const Player = preload("res://prefabs/player.tscn")
const PORT = 53431
var enet_peer = ENetMultiplayerPeer.new() 

func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_end"):
		get_tree().quit()

func _on_host_button_pressed() -> void:
	main_menu.hide()
	world.show()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
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
	print(username_entry.text)
	if username_entry.text:
		player.username = username_entry.text
	$World/Players.add_child(player)


func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
