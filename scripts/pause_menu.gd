class_name PauseMenu
extends Control

signal unpause_game


func _ready() -> void:
	self.hide()


#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("pause"):
		#self.unpause_game.emit()


func _on_return_to_game_button_pressed() -> void:
	self.unpause_game.emit()
