extends RigidBody2D

export (int) var movementSpeed = 200
export (int) var pushSpeed = 500
export (int) var xStart = 0
export (int) var yStart = 0

onready var just_aired_timer : Timer = $JustAiredTimer
onready var _transitions: = {
	IDLE: [RUN, AIR],
	RUN: [IDLE, AIR],
	AIR: [IDLE],
}

const FLOOR_NORMAL := Vector2.UP

enum {
	IDLE,
	RUN,
	AIR,
}

var _state: int = IDLE

var states_strings := {
	IDLE: "idle",
	RUN: "run",
	AIR: "air",
}

var velocity = Vector2()

func get_player_input():
	velocity = Vector2()
	if Input.is_action_pressed("push_down"):
		velocity.y -= pushSpeed
	if Input.is_action_pressed("push_up"):
		velocity.y += pushSpeed
	if Input.is_action_pressed("push_left"):
		velocity.x += pushSpeed
	if Input.is_action_pressed("push_right"):
		velocity.x -= pushSpeed
	
	velocity = velocity.normalized() * movementSpeed
	
	
	
	
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	#var is_touching_surface := state.get_contact_count() > 0
	get_player_input()
	self.apply_impulse(Vector2.ZERO, velocity)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
