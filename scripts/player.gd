class_name Player
extends CharacterBody2D

signal player_moving(direction: float)
signal player_stopped

const SPEED: float = 500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	
	if direction:
		velocity.x = direction * SPEED
		
		if direction != 0:
			self.player_moving.emit(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		self.player_stopped.emit()
	
	apply_floor_snap()
	move_and_slide()
