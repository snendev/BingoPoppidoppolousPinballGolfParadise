extends Node

var mouse_position_1 = null
var mouse_position_2 = null

const mouse_viewport_factor: float = 0.5
const arrow_size_factor = 0.05
const min_impulse: float = 10.0
const max_impulse: float = 100.0

var strokes = 0

func calculate_impulse(target: Vector2, origin: Vector2) -> Vector2:
	var delta = (target - origin) * mouse_viewport_factor
	if delta.length() < min_impulse:
		return delta.normalized() * min_impulse
	else:
		return delta.clamped(max_impulse)

func execute_stroke(impulse: Vector2):
	$Ball.apply_central_impulse(Vector3(-impulse.x, impulse.y, 0))
	strokes += 1
	$HUD/StrokesPanel/CenterContainer/HSplitContainer/NumStrokes.text = String(strokes)

func _ready():
	$PreviewArrow.visible = false

func _input(event):
	if $Ball.linear_velocity.is_equal_approx(Vector3.ZERO):
		if event.is_action_pressed("click"):
			mouse_position_1 = event.position
			$PreviewArrow.visible = true

		if event.is_action_released("click") and mouse_position_1 != null:
			mouse_position_2 = event.position
			var impulse = calculate_impulse(mouse_position_2, mouse_position_1)
			execute_stroke(impulse)
			mouse_position_1 = null
			mouse_position_2 = null
			$PreviewArrow.visible = false

func _process(delta):
	if mouse_position_1 != null:
		var preview_mouse_position = get_viewport().get_mouse_position()
		if preview_mouse_position != null:
			var preview_impulse = calculate_impulse(preview_mouse_position, mouse_position_1)
			$PreviewArrow/Body.scale.y = preview_impulse.length() * arrow_size_factor
			$PreviewArrow.rotation.z = PI/2 - preview_impulse.angle()
