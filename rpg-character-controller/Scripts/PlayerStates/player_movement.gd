extends PlayerState

# Constants defining movement speeds
const SPEED = 8.0
const JUMP_VELOCITY = 6

enum MoveState { IDLE, RUN, JUMP_START, JUMP_AIR, LAND }

var move_state = MoveState.IDLE
var last_state = null

# Called when entering this state - sets the initial idle animation
func enter(player: Player):
	last_state = null
	pass
# Called when exiting this state - currently does nothing but can be used for cleanup
func exit(player: Player):
	pass

# Main physics processing function called every physics frame
func physics_process(player: Player, delta):
	
	# Apply gravity when not on the floor
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
		if move_state != MoveState.JUMP_START:
			move_state = MoveState.JUMP_AIR

		# Handle jumping when jump button is pressed and player is on the floor
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		move_state = MoveState.JUMP_START
		
	if player.is_on_floor() and move_state == MoveState.JUMP_AIR:
		move_state = MoveState.LAND
		
	# Calculate movement direction based on input and camera orientation
	var input_dir = Input.get_vector("move_left", "move_right", "move_back", "move_forward")
	var direction = _calculate_movement_direction(player, input_dir)

	match move_state:
		MoveState.IDLE:
			#print("idling")
			_state_idle(player, delta, input_dir)
		MoveState.RUN:
			#print("running")
			_state_run(player, delta, input_dir)
		MoveState.JUMP_START:
			_state_jump_start(player, delta)
		MoveState.JUMP_AIR:
			_state_jump_air(player, delta)
		MoveState.LAND:
			_state_land(player, delta)
	
	
	# If there's movement input, set velocity and rotate the player model
	if direction != Vector3.ZERO:
		player.velocity.x = direction.x * SPEED
		player.velocity.z = direction.z * SPEED

		# Calculate the angle the player should face and smoothly rotate towards it
		var target_angle = atan2(direction.x, direction.z)
		player.model.rotation.y = lerp_angle(
			player.model.rotation.y,
			target_angle,
			10 * delta
		)
	# If no input, gradually slow down to a stop
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, SPEED)
		
	last_state = move_state

func _state_idle(player : Player, delta, input_dir):
	if last_state != move_state:
		player.anim.play("med_anims/Idle_A")
	
	if player.is_on_floor() and input_dir != Vector2.ZERO:
		move_state = MoveState.RUN
		_state_run(player, delta, input_dir)
	
func _state_run(player : Player, delta, input_dir):
	if last_state != move_state:
		player.anim.play("med_anims/Running_A")
	
	if input_dir == Vector2.ZERO:
		move_state = MoveState.IDLE
		_state_idle(player, delta, input_dir)
	
func _state_jump_start(player : Player, delta):
	if last_state != move_state:
		player.velocity.y = JUMP_VELOCITY
		player.anim.play("med_anims/Jump_Start")
		
	
func _state_jump_air(player : Player, delta):
	if last_state != move_state:
		player.anim.play("med_anims/Jump_Idle")
	
	if player.is_on_floor():
		move_state = MoveState.LAND
		
	
func _state_land(player : Player, delta):
	if last_state != move_state:
		player.anim.play("med_anims/Jump_Land")
		print("start jump end")
	if player.velocity != Vector3.ZERO:
		print("jump to move")
		move_state = MoveState.RUN
		
	
func animation_finished(player:Player, anim_name):
	match move_state:
		MoveState.JUMP_START:
			move_state = MoveState.JUMP_AIR
		MoveState.LAND:
			move_state = MoveState.IDLE
			print("finished jump end")

func change_state():
	var move_state = MoveState.IDLE
	




# Helper function to calculate the 3D movement direction relative to the camera
func _calculate_movement_direction(player: Player, input_dir: Vector2) -> Vector3:
	# If no input, no movement
	if input_dir == Vector2.ZERO:
		return Vector3.ZERO
	
	# Get the camera's forward and right directions
	var cam_basis = player.camera.global_transform.basis
	var forward = -cam_basis.z
	var right = cam_basis.x
	
	# Remove vertical component to keep movement on the horizontal plane
	forward.y = 0
	right.y = 0
	
	# Normalize the vectors for consistent movement
	forward = forward.normalized()
	right = right.normalized()
	
	# Combine forward/backward and left/right inputs into a single direction vector
	return (forward * input_dir.y + right * input_dir.x).normalized()
