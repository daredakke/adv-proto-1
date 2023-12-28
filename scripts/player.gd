class_name Player
extends CharacterBody2D

signal player_moving(direction: float)
signal player_stopped
signal player_interacting(entity: Area2D)

const SPEED: float = 500
const INTERACTION_ORIGIN_OFFSET: int = 50

# Origin point for NPC interaction is offset left or right based on player's facing
@onready var interaction_origin: Marker2D = %InteractionOrigin

@export var interaction_range: float = 125

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_has_control: bool = true
var closest_entity: Variant = null


func _ready() -> void:
	interaction_origin.position.x = INTERACTION_ORIGIN_OFFSET


func _process(delta: float) -> void:
	if !player_has_control:
		return
	
	# Talk to an NPC
	if Input.is_action_just_pressed("action") and closest_entity:
		self.player_interacting.emit(closest_entity)
		remove_player_control()


func _on_player_moving(direction: float) -> void:
	closest_entity = find_closest_entity()
	
	# Show visual indication that an NPC can be interacted with
	if closest_entity:
		closest_entity.is_selected(true)


func find_closest_entity() -> Variant:
	# Find closest NPC in range to select for interaction
	var closest_entity = null
	var closest_entity_distance: float
	
	for entity in get_tree().get_nodes_in_group("entity"):
		entity.is_selected(false)
		
		var current_entity_distance = interaction_origin.global_position.distance_to(entity.global_position)
		
		if current_entity_distance > interaction_range:
			continue
		
		if !closest_entity or current_entity_distance < closest_entity_distance:
			closest_entity = entity
			closest_entity_distance = current_entity_distance
	
	return closest_entity


func _physics_process(delta: float) -> void:
	if !player_has_control:
		return
	
	player_movement(delta)


func player_movement(delta: float) -> void:
	# Add the gravity.
	if !is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	var direction: float = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * SPEED
		
		if direction != 0:
			self.player_moving.emit(direction)
			
			interaction_origin.position.x = INTERACTION_ORIGIN_OFFSET * direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		self.player_stopped.emit()

	apply_floor_snap()
	move_and_slide()


func give_player_control() -> void:
	player_has_control = true


func remove_player_control() -> void:
	player_has_control = false
