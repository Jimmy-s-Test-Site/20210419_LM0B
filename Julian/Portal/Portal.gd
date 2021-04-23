extends Area2D

signal entered_portal(destination)

export(String) var next_level
export(bool) var follow_mouse = false

func _process(_delta : float) -> void:
	if self.follow_mouse:
		self.global_position = self.get_global_mouse_position()

func _on_CollisionArea_body_entered(_body : Node) -> void:
	self.emit_signal("entered_portal", self.next_level)
