extends Node2D

export(String) var start_level : String

onready var curr_level_path : String = self.start_level

var curr_level : Node2D
var player

func _ready() -> void:
	self.load_curr_level()

func load_curr_level() -> void:
	$FEL.set_fill(1.0)
	
	for level in $Level.get_children():
		level.disconnect("finished", self, "on_level_finished")
		level.disconnect("restart", self, "on_level_restart")
		level.player.disconnect("consumed_FEL", self, "on_player_consumed_FEL")
		level.queue_free()
	
	self.curr_level = load(self.curr_level_path).instance()
	self.curr_level.connect("ready", self, "on_level_ready")
	self.curr_level.connect("finished", self, "on_level_finished")
	self.curr_level.connect("restart", self, "on_level_restart")
	
	$Level.call_deferred("add_child", self.curr_level)

func on_level_ready() -> void:
	self.curr_level.player.connect("consumed_FEL", self, "on_player_consumed_FEL")

func on_level_restart() -> void:
	self.load_curr_level()

func on_level_finished(next_level : String) -> void:
	self.curr_level_path = next_level
	self.load_curr_level()

func on_player_consumed_FEL(new_amount : float) -> void:
	$FEL.set_fill(new_amount)
