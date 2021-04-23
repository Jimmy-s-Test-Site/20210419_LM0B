extends RigidBody2D

signal consumed_fire_extinguisher_liquid(new_total)

enum {
	IDLE,
	PROPEL,
	AIR
}

# fire extinguisher liquid
export var FEL_max := 100.0
export var FEL_amount := 100.0
export var FEL_per_sec := 0.01

export var propel_speed := 20.0
export var max_propel_speed := 200.0
export var push_force := 70.0

onready var _transitions := {
	IDLE: [PROPEL, AIR],
	PROPEL: [IDLE, AIR],
	AIR: [IDLE, PROPEL]
}

var _state : int = IDLE
var input_propel = false
var input = Vector2.ZERO


func _ready() -> void:
	$FireExtinguisher.emitting = false

func _process(delta: float) -> void:
	self.input_manager()

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	self.do_state()
	self.leave_state(state)

func _physics_process(delta: float) -> void:
	if _state == PROPEL:
		self.FEL_amount -= delta * self.FEL_per_sec
		self.FEL_amount = clamp(self.FEL_amount, 0, self.FEL_max)



func input_manager() -> void:
	self.input = Vector2(
		Input.get_action_strength("push_right") - Input.get_action_strength("push_left"),
		Input.get_action_strength("push_down")  - Input.get_action_strength("push_up")
	).normalized()
	
	self.input_propel = Input.get_action_strength("propel")



func enter_state() -> void:
	match _state:
		IDLE:
			self.linear_damp = self.propel_speed / 20
			$FireExtinguisher.emitting = false
		PROPEL:
			self.linear_damp = 0
			$FireExtinguisher.emitting = true
		AIR:
			self.linear_damp = 0
			self.apply_central_impulse(self.input * self.push_force)
			# prevents the state to change back to IDLE as ground is still
			# detected one to two frames after getting air
			$JustPushedTimer.start()
		_:
			return

func do_state() -> void:
	match self._state:
		IDLE:
			pass
		PROPEL:
			var propel_direction := (self.get_global_mouse_position() - self.global_position).normalized()
			
			self.apply_central_impulse(propel_direction.rotated(PI) * self.propel_speed)
			
			if self.linear_velocity.length() > self.max_propel_speed:
				self.linear_velocity = self.linear_velocity.normalized() * self.max_propel_speed
			
			$FireExtinguisher.process_material.direction = Vector3(propel_direction.x, propel_direction.y, 0)
		AIR:
			pass

func leave_state(state: Physics2DDirectBodyState) -> void:
	var is_touching_surface := state.get_contact_count() > 0
	
	match self._state:
		IDLE:
			if self.input_propel:
				self.change_state(PROPEL)
			elif is_touching_surface and self.input.length() > 0:
				self.change_state(AIR)
		PROPEL:
			if not self.input_propel:
				self.change_state(IDLE)
		AIR:
			if self.input_propel and $JustPushedTimer.is_stopped():
				self.change_state(PROPEL)
			elif is_touching_surface and $JustPushedTimer.is_stopped():
				self.change_state(IDLE)

func change_state(target_state : int) -> void:
	if not target_state in self._transitions[self._state]:
		return
	
	self._state = target_state
	self.enter_state()
