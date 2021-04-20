extends Area2D

export(Array, Resource) var gravity_area_nodes

export(bool) var enabled = true

func _ready() -> void:
	var is_first : bool = true
	
	for gravity_area_node_iteration in range(self.gravity_area_nodes.size()):
		var gravity_area_node = self.gravity_area_nodes[gravity_area_node_iteration]
		
		var timer : Timer = Timer.new()
		timer.set_name(str("Timer", gravity_area_node_iteration))
		timer.set_timer_process_mode(Timer.TIMER_PROCESS_IDLE)
		timer.set_wait_time(gravity_area_node.time)
		timer.set_one_shot(true)
		timer.set_autostart(false)
		timer.connect(
			"timeout",
			self,
			"timer_callback",
			[gravity_area_node_iteration, gravity_area_node.gravity]
		)
		$Timers.add_child(timer)
		
		if enabled and is_first:
			timer.start()
			is_first = false

func timer_callback(index : int, gravity_parameter : float) -> void:
	if enabled:
		self.gravity = gravity_parameter
		
		var next_timer_index : int = (index + 1) % self.gravity_area_nodes.size()
		var next_timer_name : String = str("Timer", next_timer_index)
		var next_timer_path : String = str("Timers/", next_timer_name)
		self.get_node(next_timer_path).start()
