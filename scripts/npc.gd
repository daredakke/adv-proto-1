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
@export_range(0, 60, 0.05, "suffix:s") var pause_duration: float
@export_range(1, 25, 1, "suffix:px") var tolerance: int

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_move: bool
var markers: Array[Vector2]
var marker_index: int = 0
var direction_to_marker: Vector2


func _ready() -> void:
	is_selected(false)

	if npc_texture:
		npc_sprite.texture = npc_texture
	
	wait_timer.wait_time = pause_duration
	can_move = movable
	
	if can_move:
		# NPC marked as movable but has no markers? Make it static
		if !marker_nodes.get_children():
			make_npc_static()
			
			return
		
		for marker in marker_nodes.get_children():
			markers.append(marker.global_position)
		
		direction_to_marker = get_direction_to_position(markers[marker_index], is_grounded)


func _physics_process(delta: float) -> void:
	if !can_move or !wait_timer.is_stopped():
		return
		
	if is_close_enough(self.global_position, markers[marker_index], is_grounded):
		direction_to_marker = Vector2.ZERO
		
		marker_index += 1
		
		if marker_index >= markers.size():
			marker_index = 0
			
			if !patrolling:
				make_npc_static()
		
		if pause_duration > 0:
			wait_timer.start()
		else:
			direction_to_marker = get_direction_to_position(markers[marker_index], is_grounded)
	
	velocity.x = direction_to_marker.x * speed
	
	# Add the gravity.
	if is_grounded:
		apply_floor_snap()
		
		if !is_on_floor():
			velocity.y += gravity * delta
	else:
		velocity.y = direction_to_marker.y * speed
	
	move_and_slide()


func get_direction_to_position(position: Vector2, grounded: bool) -> Vector2:
	# Get vector pointing towards target position
	var direction: Vector2 = (position - self.global_position).normalized()

	# Grounded NPCs only need to move left and right
	if is_grounded:
		if direction.x != 0:
			direction.x = clamp(direction.x * 10, -1, 1)
		
		direction.y = 0
	
	return direction


func make_npc_static() -> void:
	movable = false
	can_move = movable


func _on_wait_timer_timeout() -> void:
	direction_to_marker = get_direction_to_position(markers[marker_index], is_grounded)


func is_close_enough(position: Vector2, target: Vector2, grounded: bool) -> bool:
	var result = false
	
	if round(abs(position.x - target.x)) <= tolerance:
		result = true
	
	if !grounded and result and round(abs(position.y - target.y)) <= tolerance:
		result = true
	
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
