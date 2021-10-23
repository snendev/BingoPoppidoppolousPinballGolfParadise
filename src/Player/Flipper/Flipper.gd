extends KinematicBody

const UP_ROTATION = PI/8
const DOWN_ROTATION = -PI/8

var is_up = false 

func _ready():
	self.rotation.z = UP_ROTATION
	
func _input(event):
	if event.is_action_pressed("flip"):
		is_up = true

	if event.is_action_released("flip"):
		is_up = false

func _physics_process(delta: float):
	var target = UP_ROTATION if is_up else DOWN_ROTATION
	self.rotation.z = lerp(self.rotation.z, target, 0.15)
