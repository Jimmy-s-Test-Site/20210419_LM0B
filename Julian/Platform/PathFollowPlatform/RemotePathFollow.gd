extends Path2D

export(NodePath) var remote_path
export(float) var speed = 100.0

onready var follow = $PathFollow2D

func _ready() -> void:
	#$PathFollow2D/RemoteTransform2D.remote_path = self.remote_path
	pass

func _physics_process(delta: float) -> void:
	self.follow.offset = self.follow.offset + self.speed * delta
