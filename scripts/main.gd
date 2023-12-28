class_name Main
extends Node2D

@onready var player: Player = %Player
@onready var dialogue_box: DialogueBox = %DialogueBox


func _ready() -> void:
	player.player_interacting.connect(_on_player_interacting)
	dialogue_box.dialogue_ended.connect(_on_dialogue_ended)


func _on_player_interacting(entity: Area2D) -> void:
	if entity.is_in_group("npc"):
		dialogue_box.start_dialogue(entity.npc_id)


func _on_dialogue_ended() -> void:
	player.give_player_control()
