extends CharacterBody3D
class_name Player

@onready var anim :AnimationPlayer = $AnimationPlayer
@onready var camera = $CameraYaw/CameraPitch/Camera3D
@onready var camera_yaw = $CameraYaw
@onready var camera_pitch = $CameraYaw/CameraPitch

@export var model :Node3D

var interact_target : Node

var mouse_sensitivity = 0.003
var controller_sensitivity = 2.5
@export var hp = 3

#State Management Variables
var states = {}
enum StateName {SPAWN, MOVEMENT, DEAD, DAMAGED}
var currentState : PlayerState = null

func _ready():
	anim.root_node = model.get_path()
	states = {
		StateName.SPAWN : preload("res://Scripts/PlayerStates/player_spawn.gd").new(),
		StateName.MOVEMENT : preload("res://Scripts/PlayerStates/player_movement.gd").new(),
		StateName.DEAD : preload("res://Scripts/PlayerStates/player_dead.gd").new(),
		StateName.DAMAGED: preload("res://Scripts/PlayerStates/player_damaged.gd").new(),
		
	}

	changeState(StateName.SPAWN)  #Set the starting state for the laser

func _physics_process(delta):
	currentState.physics_process(self, delta)
	move_and_slide()
	
func _process(delta):
	var look_x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	var look_y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	
	if look_x != 0 or look_y != 0:
		look_around(-look_x * controller_sensitivity * delta, -look_y * controller_sensitivity * delta)

func _input(event):
	if event is InputEventMouseMotion:
		look_around(-event.relative.x * mouse_sensitivity, event.relative.y * mouse_sensitivity)

# New helper function to handle rotation and clamping
func look_around(delta_x: float, delta_y: float):
	camera_yaw.rotate_y(delta_x)
	camera_pitch.rotate_x(delta_y)
	camera_pitch.rotation.x = clamp(
		camera_pitch.rotation.x,
		deg_to_rad(-20),
		deg_to_rad(40)
	)

func changeState(newState):
	print("moving to " + StateName.keys()[newState])
	if currentState:
		currentState.exit(self)
	currentState = states[newState]
	currentState.enter(self)

func _animation_finished(anim_name):
	currentState.animation_finished(self, anim_name)


func _take_damage(dmg:int):
	hp -= dmg
	if hp <= 0:
		changeState(StateName.DEAD)
	else:
		changeState(StateName.DAMAGED)
		

func _unhandled_input(event):
	if event.is_action_pressed("Interact") and interact_target != null:
		interact_target.interact()
