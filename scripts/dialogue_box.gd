class_name DialogueBox
extends Control

signal dialogue_ended

@onready var next_char_timer: Timer = %NextCharTimer
@onready var portrait_margin: MarginContainer = %PortraitMargin
@onready var portrait_texture: TextureRect = %PortraitTexture
@onready var speaker_panel: Panel = %SpeakerPanel
@onready var speaker_label: Label = %SpeakerLabel
@onready var body_label: RichTextLabel = %BodyLabel
@onready var next_line_arrow: TextureRect = %NextLineArrow

var npc_id: int
var lines: Array
var next_line: String = ""
var stored_portrait = null
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
	
	show()
	
	# Prevent advancing twice if text speed is set to instant
	if Input.is_action_just_pressed("action"):
		return
	
	advance_line()


func advance_line() -> void:
	if current_line_index >= lines.size():
		end_dialogue()
		
		return
	
	next_char_timer.wait_time = GameOptions.text_speed
	
	var speaker: String = lines[current_line_index]["speaker"]
	speaker_label.text = speaker
	
	if speaker == "":
		speaker_panel.modulate = Color.TRANSPARENT
	else:
		speaker_panel.modulate = Color.WHITE
	
	if lines[current_line_index].has("portrait"):
		portrait_texture.texture = lines[current_line_index]["portrait"]
		
		portrait_texture.show()
		
		if speaker == NpcData.MC_NAME:
			portrait_margin.set_offsets_preset(Control.PRESET_BOTTOM_LEFT)
			
			portrait_texture.flip_h = false
		else:
			portrait_margin.set_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
			
			portrait_texture.flip_h = true
	else:
		portrait_texture.hide()
	
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
		next_line_arrow.hide()


func to_next_line() -> void:
	current_line_index += 1
	next_line = ""
	
	next_line_arrow.show()


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
	hide()
	next_line_arrow.hide()
	portrait_texture.hide()
