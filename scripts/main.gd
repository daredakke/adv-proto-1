class_name Main
extends Node2D

signal pause_game
signal toggle_fullscreen(state: bool)

@onready var title_screen: Control = %TitleScreen
@onready var level: Node2D = %Level
@onready var player: Player = %Player
@onready var dialogue_box: DialogueBox = %DialogueBox
@onready var pause_menu: Control = %PauseMenu

@export var start_at_title_screen: bool = true

var game_paused: bool = false
var game_is_fullscreen: bool = false


func _ready() -> void:
	title_screen.start_game.connect(_on_title_screen_start_game)
	player.player_interacting.connect(_on_player_interacting)
	dialogue_box.dialogue_ended.connect(_on_dialogue_ended)
	pause_menu.unpause_game.connect(_on_pause_game)
	pause_menu.quit_game.connect(_on_quit_game)
	
	if start_at_title_screen:
		game_init()
	else:
		game_start()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		self.pause_game.emit()
	
	if Input.is_action_just_pressed("toggle_fullscreen"):
		self.toggle_fullscreen.emit(!game_is_fullscreen)


func _on_player_interacting(entity: Area2D) -> void:
	if entity.is_in_group("npc"):
		dialogue_box.start_dialogue(entity.npc_id)


func _on_title_screen_start_game() -> void:
	game_start()


func _on_dialogue_ended() -> void:
	player.give_player_control()


func game_init() -> void:
	game_paused = true
	get_tree().paused = true
	title_screen.show()
	title_screen.set_process(true)


func game_start() -> void:
	game_paused = false
	get_tree().paused = false
	title_screen.hide()
	title_screen.set_process(false)


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


func _on_pause_menu_set_text_speed(speed: GameOptions.TextSpeed) -> void:
	GameOptions.set_text_speed(speed)
