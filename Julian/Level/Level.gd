extends Node

signal finished(next_level)
signal restart

onready var player = $Player

func _on_Portal_entered_portal(destination : String) -> void:
	self.emit_signal("finished", destination)
