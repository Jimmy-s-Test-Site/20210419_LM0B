extends Area2D

signal entered_portal

func _process(delta : float) -> void:
	var velocity = self.get_global_mouse_position() - self.global_position
	self.global_position += velocity

func _on_CollisionArea_area_entered(area : Area2D) -> void:
	self.emit_signal("entered_portal")
