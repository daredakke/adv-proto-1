extends Node

enum TextSpeed {
	INSTANT,
	FAST,
	MEDIUM,
	SLOW
}

var text_speed: float


func _ready() -> void:
	set_text_speed(TextSpeed.FAST)


func set_text_speed(speed: TextSpeed):
	if TextSpeed.find_key(speed):
		text_speed = speed * 0.01
