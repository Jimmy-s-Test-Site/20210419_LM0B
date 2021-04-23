extends Node

signal finished(next_level)
signal restart

func _on_Portal_entered_portal(destination : String) -> void:
	self.emit_signal("finished", destination)
