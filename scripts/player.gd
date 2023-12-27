class_name Player
extends CharacterBody2D

signal player_moving(direction: float)
signal player_stopped

const SPEED: float = 500.0
const INTERACTION_ORIGIN_OFFSET: int = 60

@onready var interaction_origin: Marker2D = %InteractionOrigin

@export var interaction_range: float = 125

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	interaction_origin.position.x = INTERACTION_ORIGIN_OFFSET


func _process(delta: float) -> void:
	var closest_npc = null
	var closest_npc_distance: float = 0
	
	for npc in get_tree().get_nodes_in_group("npc"):
		npc.is_selected(false)
		
		var current_npc_distance = interaction_origin.global_position.distance_to(npc.global_position)
		
		if current_npc_distance > interaction_range:
			continue
		
		if closest_npc == null or current_npc_distance < closest_npc_distance:
			closest_npc = npc
			closest_npc_distance = current_npc_distance
	
	if closest_npc != null:
		closest_npc.is_selected(true)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
