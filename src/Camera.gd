extends Camera

const camera_offset_y = 20.0
const padding = 40.0
const max_offset = 50.0

const min_weight = 0.01
const max_weight = 0.05

func get_drift_weight(camera_y: float, target_y: float) -> float:
	var adjusted_offset = min((camera_y - (target_y - padding)) / max_offset, 1)
	var weight_scale = ease(adjusted_offset, 5.0)
	var weight = min_weight + weight_scale * (max_weight - min_weight)
	return weight

## get ball position and LERP
func _process(delta):
	var ball_node = get_node("/root/Root/Player/Ball")
	var ball_position = ball_node.get_global_transform().origin.y
	var target_position = ball_position + camera_offset_y
	var camera_position = self.translation.y
	var weight = get_drift_weight(camera_position, target_position)

	var drifted_position = lerp(camera_position, target_position, weight)
	self.translation.y = drifted_position
