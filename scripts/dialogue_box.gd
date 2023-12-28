class_name DialogueBox
extends Control

signal dialogue_ended

@onready var next_char_timer: Timer = %NextCharTimer
@onready var avatar_texture: TextureRect = %AvatarTexture
@onready var speaker_label: Label = %SpeakerLabel
@onready var body_label: RichTextLabel = %BodyLabel
@onready var next_line_arrow: TextureRect = %NextLineArrow

var npc_id: int
var lines: Array
var next_line: String = ""
var current_line_index: int = 0


func _ready() -> void:
	next_char_timer.wait_time = GameOptions.text_speed
	
	hide_all()


func _process(delta: float) -> void:
	if self.visible:
		if Input.is_action_just_pressed("debug_end_dialogue"):
			end_dialogue()
		
		if Input.is_action_just_pressed("action"):
			advance_line()


func start_dialogue(npc_id: int) -> void:
	lines = NpcData.lines[npc_id]
	
	show_self()
	advance_line()


func advance_line() -> void:
	if current_line_index >= lines.size():
		end_dialogue()
		
		return
	
	speaker_label.text = lines[current_line_index]["speaker"]
	
	# Complete the line if text is in process of being displayed
	if next_line.length() > 0:
		complete_line()
		
		return
	
	# Instant text reveal
	if GameOptions.text_speed == 0:
		complete_line()
		
		return
	
	# Start displaying text char by char
	if next_char_timer.is_stopped():
		next_char_timer.start()
		hide_next_line_arrow()


func to_next_line() -> void:
	current_line_index += 1
	next_line = ""
	
	show_next_line_arrow()


func complete_line() -> void:
	if !next_char_timer.is_stopped():
		next_char_timer.stop()
	
	body_label.clear()
	body_label.append_text(lines[current_line_index]["line"])
	
	to_next_line()


func _on_next_char_timer_timeout() -> void:
	# Add the next char to the currently displayed line
	next_line += lines[current_line_index]["line"][next_line.length()]
	
	body_label.clear()
	body_label.append_text(next_line)
	
	if next_line.length() < lines[current_line_index]["line"].length():
		next_char_timer.start()
	else:
		to_next_line()


func end_dialogue() -> void:
	if !next_char_timer.is_stopped():
		next_char_timer.stop()
	
	lines = []
	next_line = ""
	current_line_index = 0
	speaker_label.text = ""
	
	body_label.clear()
	hide_all()
	
	self.dialogue_ended.emit()


func hide_all() -> void:
	hide_self()
	hide_next_line_arrow()
	hide_avatar_texture()


func show_self() -> void:
	self.visible = true


func hide_self() -> void:
	self.visible = false


func show_next_line_arrow() -> void:
	next_line_arrow.visible = true


func hide_next_line_arrow() -> void:
	next_line_arrow.visible = false


func show_avatar_texture() -> void:
	avatar_texture.visible = true


func hide_avatar_texture() -> void:
	avatar_texture.visible = false
