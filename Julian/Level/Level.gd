extends Node

signal finished(next_level)
signal restart

onready var player = $Player

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		self.emit_signal("restart")

func _on_Portal_entered_portal(destination : String, exit_portal : String) -> void:
	self.emit_signal("finished", destination, exit_portal)
