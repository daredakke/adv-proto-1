class_name Player
extends CharacterBody2D

signal player_moving(direction: float)
signal player_stopped
signal player_interacting(npc: Area2D)

const SPEED: float = 500
const INTERACTION_ORIGIN_OFFSET: int = 50

# Origin point for NPC interaction is offset left or right based on player's facing
@onready var interaction_origin: Marker2D = %InteractionOrigin

@export var interaction_range: float = 125

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_has_control: bool = true
var closest_npc: Variant = null


func _ready() -> void:
	interaction_origin.position.x = INTERACTION_ORIGIN_OFFSET


func _process(delta: float) -> void:
	if !player_has_control:
		return
	
	# Talk to an NPC
	if Input.is_action_just_pressed("action") and closest_npc:
		self.player_interacting.emit(closest_npc)
		remove_player_control()


func _on_player_moving(direction: float) -> void:
	closest_npc = find_closest_npc()
	
	# Show visual indication that an NPC can be interacted with
	if closest_npc:
		closest_npc.is_selected(true)


func find_closest_npc() -> Variant:
	# Find closest NPC in range to select for interaction
	var closest_npc = null
	var closest_npc_distance: float = 0
	
	for npc in get_tree().get_nodes_in_group("npc"):
		npc.is_selected(false)
		
		var current_npc_distance = interaction_origin.global_position.distance_to(npc.global_position)
		
		if current_npc_distance > interaction_range:
			continue
		
		if !closest_npc or current_npc_distance < closest_npc_distance:
			closest_npc = npc
			closest_npc_distance = current_npc_distance
	
	return closest_npc


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
