class_name TitleScreen
extends Control

signal start_game


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("action") and !Input.is_action_just_pressed("toggle_fullscreen"):
		self.start_game.emit()


func _on_start_game_button_pressed() -> void:
	self.start_game.emit()
