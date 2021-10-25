extends KinematicBody

const UP_ROTATION = PI/8
const DOWN_ROTATION = -PI/8

export var REVERSE = false

onready var up = DOWN_ROTATION if REVERSE else UP_ROTATION
onready var down = UP_ROTATION if REVERSE else DOWN_ROTATION
var is_up = false

func _ready():
	self.rotation.z = up

func _input(event):
	if event.is_action_pressed("flip"):
		is_up = true

	if event.is_action_released("flip"):
		is_up = false

func _physics_process(delta: float):
	var target = up if is_up else down
	self.rotation.z = lerp(self.rotation.z, target, 0.15)
