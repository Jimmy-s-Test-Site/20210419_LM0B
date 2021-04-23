extends Node2D

export(String) var start_level : String

onready var curr_level_path : String = self.start_level
var curr_level : Node2D

func _ready() -> void:
	self.load_curr_level()

func load_curr_level():
	for level in $Level.get_children():
		level.disconnect("finished", self, "on_level_finished")
		level.disconnect("restart", self, "on_level_restart")
		level.queue_free()
	
	self.curr_level = load(self.curr_level_path).instance()
	self.curr_level.connect("finished", self, "on_level_finished")
	self.curr_level.connect("restart", self, "on_level_restart")
	
	$Level.call_deferred("add_child", self.curr_level)

func on_level_restart():
	self.load_curr_level()

func on_level_finished(next_level : String):
	self.curr_level_path = next_level
	self.load_curr_level()
