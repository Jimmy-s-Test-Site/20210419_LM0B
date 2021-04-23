extends Area2D

signal entered_portal(destination, exit_portal)

export(String) var next_level
export(String) var exit_portal
export(bool) var follow_mouse = false

func _process(_delta : float) -> void:
	if self.follow_mouse:
		self.global_position = self.get_global_mouse_position()

func _on_CollisionArea_body_entered(_body : Node) -> void:
	if $PortalEntryTimer.is_stopped():
		self.emit_signal("entered_portal", self.next_level, self.exit_portal)
