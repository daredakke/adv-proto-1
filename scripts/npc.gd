class_name Npc
extends Area2D

const SELECTED_ARROW_GAP: int = 24

@onready var npc_sprite: Sprite2D = $NPCSprite
@onready var selected_arrow: Sprite2D = $SelectedArrow
@onready var wait_timer: Timer = $WaitTimer
@onready var marker_nodes: Node2D = $Markers

@export var npc_texture: Texture2D
@export var npc_id: NpcData.ID

@export_category("NPC Movement")
@export var can_move: bool = false
@export var is_grounded: bool = true
@export var patrol: bool = true
@export_range(0, 1000) var speed: float = 200
@export_range(0, 60) var pause_duration: float

var npc_gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var markers: Array[Vector2]
var next_marker_index: int = 0
var direction_to_marker: Vector2


func _ready() -> void:
	is_selected(false)
	
	wait_timer.wait_time = pause_duration
	
	if can_move and marker_nodes.get_children():
		for marker in marker_nodes.get_children():
			markers.append(marker.global_position)
		
		direction_to_marker = get_direction_to_next_coord()
		print(npc_id, direction_to_marker)

	if npc_texture:
		npc_sprite.texture = npc_texture


func _process(delta: float) -> void:
	pass


func get_direction_to_next_coord() -> Vector2:
	if markers.size() > 0 and next_marker_index < markers.size():
		# Get vector pointing towards target position
		var direction: Vector2 = markers[next_marker_index] - self.global_position
		direction = direction.normalized()

		# Grounded NPCs only need to move left and right
		if is_grounded:
			if direction.x != 0:
				direction.x = clamp(direction.x * 10, -1, 1)
			
			direction.y = 0
		
		return direction
	
	return Vector2.ZERO


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
