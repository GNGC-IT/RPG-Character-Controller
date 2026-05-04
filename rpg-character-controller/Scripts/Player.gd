extends CharacterBody3D
class_name Player

var ANIM_PROFILES = {
	"default": {
		"spawn"      : "med_anims/Spawn_Ground",
		"idle"       : "med_anims/Idle_A",
		"move"       : "med_anims/Running_A",
		"jump_start" : "med_anims/Jump_Start",
		"jump_idle"  : "med_anims/Jump_Idle",
		"jump_land"  : "med_anims/Jump_Land",
		"death"      : "med_anims/Death_A",
		"hit"        : "med_anims/Hit_B"
	},
	"big_guy": {
		"spawn"      : "large_anims/Flexing",
		"idle"       : "large_anims/Idle_A",
		"move"       : "large_anims/Running_A",
		"jump_start" : "large_anims/Jump_Start",
		"jump_idle"  : "large_anims/Jump_Idle",
		"jump_land"  : "large_anims/Jump_Land",
		"death"      : "large_anims/Death_A",
		"hit"        : "large_anims/Hit_A"
	}
}

@export_enum("default", "big_guy") var character_profile: String = "default"

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
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	anim.root_node = model.get_path()
	states = {
		StateName.SPAWN : preload("res://Scripts/PlayerStates/player_spawn.gd").new(),
		#StateName.MOVEMENT : preload("res://Scripts/PlayerStates/new_player_movement.gd").new(),
		StateName.DEAD : preload("res://Scripts/PlayerStates/player_dead.gd").new(),
		StateName.DAMAGED: preload("res://Scripts/PlayerStates/player_damaged.gd").new(),
	}
	
	if character_profile == "default":
		states[StateName.MOVEMENT] = preload("res://Scripts/PlayerStates/med_player_movement.gd").new()
	elif character_profile == "big_guy":
		states[StateName.MOVEMENT] = preload("res://Scripts/PlayerStates/big_player_movement.gd").new()
		
	changeState(StateName.SPAWN)

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
	print(anim_name)
	currentState.animation_finished(self, anim_name)

func _set_anim(anim_name):
	anim.play(ANIM_PROFILES[character_profile][anim_name])

func _take_damage(dmg:int):
	hp -= dmg
	if hp <= 0:
		changeState(StateName.DEAD)
	else:
		changeState(StateName.DAMAGED)
		
func _unhandled_input(event):
	if event.is_action_pressed("Interact") and interact_target != null:
		interact_target.interact()
