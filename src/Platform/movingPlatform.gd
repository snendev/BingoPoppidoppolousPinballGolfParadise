extends KinematicBody

export var MAX_RIGHT_X: float = 1.0 
export var MIN_RIGHT_X: float = 1.0

const SPEED = 50.0
const RIGHT = Vector3(SPEED, 0, 0)
const LEFT = Vector3(-SPEED, 0, 0)

var velocity

func get_velocity():
	return self.velocity

func _ready():
	self.velocity = RIGHT

func _physics_process(delta):
	self.translate(self.velocity * delta)
	if self.translation.x > MAX_RIGHT_X:
		self.velocity = LEFT

	if self.translation.x < MIN_RIGHT_X:
		self.velocity = RIGHT
