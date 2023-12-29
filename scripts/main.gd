class_name Main
extends Node2D

signal pause_game
signal toggle_fullscreen(state: bool)

@onready var level: Node2D = %Level
@onready var player: Player = %Player
@onready var dialogue_box: DialogueBox = %DialogueBox
@onready var pause_menu: Control = %PauseMenu

var game_paused: bool = false
var game_is_fullscreen: bool = false


func _ready() -> void:
	player.player_interacting.connect(_on_player_interacting)
	dialogue_box.dialogue_ended.connect(_on_dialogue_ended)
	pause_menu.unpause_game.connect(_on_pause_game)
	pause_menu.quit_game.connect(_on_quit_game)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		self.pause_game.emit()
	
	if Input.is_action_just_pressed("toggle_fullscreen"):
		self.toggle_fullscreen.emit(!game_is_fullscreen)


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


func _on_pause_menu_toggle_fullscreen(state: bool) -> void:
	game_is_fullscreen = state
	
	if state:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		ProjectSettings.set_setting("display/window/size/borderless", false)


func _on_toggle_fullscreen(state: bool) -> void:
	pause_menu.toggle_fullscreen_check_box(state)


func _on_quit_game() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
