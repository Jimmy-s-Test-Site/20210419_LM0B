extends Area2D

signal entered_portal

export(bool) var follow_player = false

func _process(_delta : float) -> void:
	if self.follow_player:
		self.global_position = self.get_global_mouse_position()

func _on_CollisionArea_body_entered(_body : Node) -> void:
	self.emit_signal("entered_portal")
