class_name Camera
extends Camera2D

@onready var position_reset_timer: Timer = %PositionResetTimer

@export var target: Node = null
@export var offset_distance_x: float = 100
@export var offset_distance_y: float = 125
@export var speed_fast: float = 10
@export var speed_slow: float = 2
@export var smoothing: float = 0.5
@export var position_reset_wait_time: float = 1.5

var last_direction: int = 0
var stop_action_complete: bool = false


func _ready() -> void:
	position_reset_timer.wait_time = position_reset_wait_time
	
	if target:
		self.position = target.position


func _process(delta: float) -> void:
	var offset_x: float = offset_distance_x * last_direction
	
	if target:
		self.position.x = target.position.x + offset_x
		self.position.y = target.position.y - offset_distance_y


func _on_player_moving(direction: float) -> void:
	last_direction = direction
	stop_action_complete = false
	
	if self.position_smoothing_speed < speed_fast:
		var new_smoothing_speed: float = self.position_smoothing_speed + smoothing
		self.position_smoothing_speed = clampf(new_smoothing_speed, 0, speed_fast)


func _on_player_stopped() -> void:
	if !stop_action_complete:
		position_reset_timer.start()
		stop_action_complete = true
	

func _on_position_reset_timer_timeout() -> void:
	self.position_smoothing_speed = speed_slow
	last_direction = 0
