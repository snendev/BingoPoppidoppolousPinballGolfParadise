extends Spatial

const X_SCALE_FACTOR: float = 0.9
const X_OFFSET: float = 90.0

onready var player_node = get_node("/root/Root/Player")
onready var ball_node = get_node("/root/Root/Player/Ball")

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

	var state_machine = $AnimationPlayer/AnimationTree["parameters/playback"]
	if player_node.is_position_improving():
		state_machine.travel("smile")
	else:
		state_machine.travel("frown")
