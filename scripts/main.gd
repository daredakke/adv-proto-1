class_name Main
extends Node2D

signal pause_game

@onready var level: Node2D = %Level
@onready var player: Player = %Player
@onready var dialogue_box: DialogueBox = %DialogueBox
@onready var pause_menu: Control = %PauseMenu

var game_paused: bool = false


func _ready() -> void:
	player.player_interacting.connect(_on_player_interacting)
	dialogue_box.dialogue_ended.connect(_on_dialogue_ended)
	pause_menu.unpause_game.connect(_on_pause_game)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		self.pause_game.emit()


func _on_player_interacting(entity: Area2D) -> void:
	if entity.is_in_group("npc"):
		dialogue_box.start_dialogue(entity.npc_id)


func _on_dialogue_ended() -> void:
	player.give_player_control()


func _on_pause_game() -> void:
	game_paused = !game_paused
	
	if game_paused:
		get_tree().paused = true
		pause_menu.show()
	else:
		get_tree().paused = false
		pause_menu.hide()
