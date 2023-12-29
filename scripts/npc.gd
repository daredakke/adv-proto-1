class_name Npc
extends CharacterBody2D

const SELECTED_ARROW_GAP: int = 24

@onready var npc_sprite: Sprite2D = $NPCSprite
@onready var selected_arrow: Sprite2D = $SelectedArrow
@onready var wait_timer: Timer = $WaitTimer
@onready var marker_nodes: Node2D = $Markers

@export var npc_texture: Texture2D
@export var npc_id: NpcData.ID

@export_category("NPC Movement")
@export var movable: bool = false
@export var is_grounded: bool = true
@export var patrolling: bool = true
@export_range(0, 1000) var speed: float = 200
@export_range(0, 60) var pause_duration: float

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_move: bool
var markers: Array[Vector2]
var marker_index: int = 0
var direction_to_marker: Vector2


func _ready() -> void:
	is_selected(false)
	
	wait_timer.wait_time = pause_duration
	can_move = movable
	
	if can_move and marker_nodes.get_children():
		for marker in marker_nodes.get_children():
			markers.append(marker.global_position)
		
		direction_to_marker = get_direction_to_next_coord()

	if npc_texture:
		npc_sprite.texture = npc_texture


func _physics_process(delta: float) -> void:
	if !can_move or !wait_timer.is_stopped():
		return
		
	if is_close_enough(self.global_position, markers[marker_index], is_grounded):
		direction_to_marker = Vector2.ZERO
		
		marker_index += 1
		
		if marker_index >= markers.size():
			if patrolling:
				# Start over
				marker_index = 0
			else:
				# Stop moving
				movable = false
				can_move = movable
		
		if pause_duration > 0:
			wait_timer.start()
		else:
			direction_to_marker = get_direction_to_next_coord()
	
	velocity.x = direction_to_marker.x * speed
	
	# Add the gravity.
	if is_grounded:
		apply_floor_snap()
		
		if !is_on_floor():
			velocity.y += gravity * delta
	else:
		velocity.y = direction_to_marker.y * speed
	
	move_and_slide()


func get_direction_to_next_coord() -> Vector2:
	if markers.size() == 0 or marker_index >= markers.size():
		return Vector2.ZERO
	
	# Get vector pointing towards target position
	var direction: Vector2 = markers[marker_index] - self.global_position
	direction = direction.normalized()

	# Grounded NPCs only need to move left and right
	if is_grounded:
		if direction.x != 0:
			direction.x = clamp(direction.x * 10, -1, 1)
		
		direction.y = 0
	
	return direction


func _on_wait_timer_timeout() -> void:
	direction_to_marker = get_direction_to_next_coord()


func is_close_enough(position: Vector2, target: Vector2, grounded: bool) -> bool:
	var result = false
	
	if abs(position.x - target.x) < 1:
		result = true
	
	if !grounded and result and abs(position.y - target.y) < 1:
		return true
	
	return result


func npc_can_move(state: bool) -> void:
	if movable:
		can_move = state


func is_selected(state: bool) -> void:
	selected_arrow.visible = state


func _on_npc_texture_changed() -> void:
	anchor_sprite_to_npc_base()
	place_selected_arrow_over_npc_head()


func anchor_sprite_to_npc_base() -> void:
	var sprite_height: float = npc_sprite.get_rect().size.y
	var npc_height: float = abs(npc_sprite.position.y * 2)
	var new_sprite_y_position: float = (npc_height - sprite_height) * 0.5
	
	npc_sprite.position.y += new_sprite_y_position


func place_selected_arrow_over_npc_head() -> void:
	var sprite_top: float = -npc_sprite.get_rect().size.y
	
	selected_arrow.position.y = sprite_top - SELECTED_ARROW_GAP
