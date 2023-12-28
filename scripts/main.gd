class_name Main
extends Node2D

@onready var player: Player = %Player
@onready var dialogue_box: DialogueBox = %DialogueBox


func _ready() -> void:
	player.player_talking.connect(_on_player_talking)
	dialogue_box.dialogue_ended.connect(_on_dialogue_ended)


func _on_player_talking(npc_id: int) -> void:
	print_debug(npc_id)
	dialogue_box.start_dialogue(npc_id)


func _on_dialogue_ended() -> void:
	player.give_player_control()
