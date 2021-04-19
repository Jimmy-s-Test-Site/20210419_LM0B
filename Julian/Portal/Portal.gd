extends Area2D

func _process(delta : float) -> void:
	var velocity = self.get_global_mouse_position() - self.global_position
	self.global_position += velocity
