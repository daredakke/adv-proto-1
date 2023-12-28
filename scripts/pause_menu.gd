class_name PauseMenu
extends Control

signal unpause_game

@onready var music_volume_change_timer: Timer = %MusicVolumeChangeTimer
@onready var music_level_label: Label = %MusicLevelLabel
@onready var music_slider: HSlider = %MusicSlider

@onready var sfx_volume_change_timer: Timer = %SFXVolumeChangeTimer
@onready var sfx_level_label: Label = %SFXLevelLabel
@onready var sfx_slider: HSlider = %SFXSlider


func _ready() -> void:
	self.hide()


func _on_return_to_game_button_pressed() -> void:
	self.unpause_game.emit()


func _on_music_slider_value_changed(value: float) -> void:
	if music_volume_change_timer.is_stopped():
		music_volume_change_timer.start()


func _on_music_volume_change_timer_timeout() -> void:
	music_level_label.text = str(music_slider.value) + "%"


func _on_sfx_slider_value_changed(value: float) -> void:
	if sfx_volume_change_timer.is_stopped():
		sfx_volume_change_timer.start()


func _on_sfx_volume_change_timer_timeout() -> void:
	sfx_level_label.text = str(sfx_slider.value) + "%"