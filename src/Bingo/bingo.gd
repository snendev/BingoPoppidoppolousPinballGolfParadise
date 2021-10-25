extends Spatial

const X_SCALE_FACTOR: float = 0.9
const X_OFFSET: float = 90.0

onready var player_node = get_node("/root/Root/Player")
onready var ball_node = get_node("/root/Root/Player/Ball")

export var DRIFT_SIZE = 4.0

var time = 0

func _process(delta):
	var ball_position = ball_node.get_global_transform().origin
	var eye_target: Vector3 = Vector3(
		# get some sense of the relative x-offset, and always point a bit right
		self.translation.x + (ball_position.x * X_SCALE_FACTOR) + X_OFFSET,
		ball_position.y,
		90.0
	)

	$LeftEye/Eye.look_at(eye_target, Vector3.UP)
	$RightEye/Eye.look_at(eye_target, Vector3.UP)

	time += delta
	var drift_x = cos(time * PI / 3) - sin(4 * time * PI / 7) * 2
	var drift_y = sin(time * PI / 3) - cos(4 * time * PI / 7) * 2

	var drifted_position = lerp( \
		self.translation, \
		self.translation + Vector3(drift_x, drift_y, 0.0) * DRIFT_SIZE * delta, \
		1.5)
	self.translation = drifted_position

	var state_machine = $AnimationPlayer/AnimationTree["parameters/playback"]
	if player_node.is_position_improving():
		state_machine.travel("smile")
	else:
		state_machine.travel("frown")
