extends Line2D

export(float, 0.0, 1.0) var fill := 1.0

onready var start_length = self.points[1].x

func _ready() -> void:
	self.set_fill(self.fill)

func set_fill(new_fill : float) -> void:
	self.fill = new_fill
	self.points[1].x = self.start_length * self.fill
