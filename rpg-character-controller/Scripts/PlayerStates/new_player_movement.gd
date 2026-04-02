extends PlayerState

const SPEED = 8.0
const JUMP_VELOCITY = 6

enum MoveState { IDLE, RUN, JUMP_START, JUMP_AIR, LAND }

var move_state = MoveState.IDLE
var last_state = null
var state_just_entered = false


func change_state(new_state):
	if move_state == new_state:
		return
	
	last_state = move_state
	move_state = new_state
	state_just_entered = true


func enter(player: Player):
	move_state = MoveState.IDLE
	last_state = null
	state_just_entered = true


func physics_process(player: Player, delta):

	var was_just_entered = state_just_entered
	state_just_entered = false

	# Gravity
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
		
		if move_state != MoveState.JUMP_START:
			change_state(MoveState.JUMP_AIR)

	# Jump
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		change_state(MoveState.JUMP_START)

	# Landing detection
	if player.is_on_floor() and move_state == MoveState.JUMP_AIR:
		change_state(MoveState.LAND)

	var input_dir = Input.get_vector("move_left", "move_right", "move_back", "move_forward")
	var direction = _calculate_movement_direction(player, input_dir)

	match move_state:
		MoveState.IDLE:
			_state_idle(player, delta, input_dir, was_just_entered)

		MoveState.RUN:
			_state_run(player, delta, input_dir, was_just_entered)

		MoveState.JUMP_START:
			_state_jump_start(player, was_just_entered)

		MoveState.JUMP_AIR:
			_state_jump_air(player, was_just_entered)

		MoveState.LAND:
			_state_land(player, input_dir, was_just_entered)


	if direction != Vector3.ZERO:
		player.velocity.x = direction.x * SPEED
		player.velocity.z = direction.z * SPEED

		var target_angle = atan2(direction.x, direction.z)
		player.model.rotation.y = lerp_angle(
			player.model.rotation.y,
			target_angle,
			10 * delta
		)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, SPEED)
		player.velocity.z = move_toward(player.velocity.z, 0, SPEED)



func _state_idle(player, delta, input_dir, entered):
	if entered:
		player.anim.play("med_anims/Idle_A")

	if input_dir != Vector2.ZERO:
		change_state(MoveState.RUN)


func _state_run(player, delta, input_dir, entered):
	if entered:
		player.anim.play("med_anims/Running_A")

	if input_dir == Vector2.ZERO:
		change_state(MoveState.IDLE)


func _state_jump_start(player, entered):
	if entered:
		player.velocity.y = JUMP_VELOCITY
		player.anim.play("med_anims/Jump_Start")


func _state_jump_air(player, entered):
	if entered:
		player.anim.play("med_anims/Jump_Idle")


func _state_land(player, input_dir, entered):
	if entered:
		player.anim.play("med_anims/Jump_Land")

	# OPTIONAL: allow early movement interrupt
	if input_dir != Vector2.ZERO:
		change_state(MoveState.RUN)


func animation_finished(player: Player, anim_name):
	match move_state:
		MoveState.JUMP_START:
			change_state(MoveState.JUMP_AIR)

		MoveState.LAND:
			change_state(MoveState.IDLE)


func _calculate_movement_direction(player: Player, input_dir: Vector2) -> Vector3:
	if input_dir == Vector2.ZERO:
		return Vector3.ZERO

	var cam_basis = player.camera.global_transform.basis
	var forward = -cam_basis.z
	var right = cam_basis.x

	forward.y = 0
	right.y = 0

	forward = forward.normalized()
	right = right.normalized()

	return (forward * input_dir.y + right * input_dir.x).normalized()
