extends KinematicBody

export var MAX_RIGHT_X: float = 1.0 
export var MIN_RIGHT_X: float = 1.0
export var SPEED: float = 10.0
export var REVERSE: bool = false

var RIGHT = Vector3(SPEED, 0, 0)
var LEFT = Vector3(-SPEED, 0, 0)

var velocity

func get_velocity():
	return self.velocity

func _ready():
	self.velocity = LEFT if REVERSE else RIGHT

func _physics_process(delta):
	self.global_translate(self.velocity * delta)
	if self.translation.x > MAX_RIGHT_X:
		self.velocity = LEFT

	if self.translation.x < MIN_RIGHT_X:
		self.velocity = RIGHT
