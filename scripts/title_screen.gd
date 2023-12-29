class_name TitleScreen
extends Control

signal start_game


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		self.start_game.emit()


func _on_start_game_button_pressed() -> void:
	self.start_game.emit()
