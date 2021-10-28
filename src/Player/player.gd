extends Node

var mouse_position_1 = null
var mouse_position_2 = null

const mouse_viewport_factor: float = 0.5
const arrow_size_factor = 0.05
const min_impulse: float = 10.0
const max_impulse: float = 100.0

export var strokes = 0
var best_score = 0

var last_settled_y = 0
var has_worsened_this_stroke = false

func save_game():
	var save_file = File.new()
	save_file.open("user://savegame.save", File.WRITE)
	var save_data = {
		"x": $Ball.translation.x,
		"y": $Ball.translation.y,
		"strokes": strokes,
		"best_score": best_score
	}
	save_file.store_line(to_json(save_data))
	save_file.close()

func load_game():
	var load_file = File.new()
	load_file.open("user://savegame.save", File.READ)
	var node_data = parse_json(load_file.get_line())
	self.reset()
	self.set_strokes(node_data["strokes"])
	self.set_best_score(node_data["best_score"])
	$Ball.translation.x = node_data["x"]
	$Ball.translation.y = node_data["y"]
	load_file.close()

func calculate_impulse(target: Vector2, origin: Vector2) -> Vector2:
	var delta = (target - origin) * mouse_viewport_factor
	if delta.length() < min_impulse:
		return delta.normalized() * min_impulse
	else:
		return delta.clamped(max_impulse)

func set_strokes(value):
	self.strokes = value
	$HUD/HBox/Flex/VBox/Strokes/CenterContainer/HSplitContainer/NumStrokes.text = String(value)

func set_best_score(value):
	self.best_score = value
	$HUD/HBox/Flex/VBox/Best/CenterContainer/HSplitContainer/BestScore.text = String(value)

func execute_stroke(impulse: Vector2):
	$Ball.apply_central_impulse(Vector3(-impulse.x, impulse.y, 0))
	$Audio/PuttPlayer.play()
	self.set_strokes(strokes + 1)
	self.last_settled_y = $Ball.global_transform.origin.y
	has_worsened_this_stroke = false

func reset():
	self.translation.x = 0.0
	self.translation.y = 40.0
	self.set_strokes(0)

func is_on_moving_floor():
	var is_in_contact = $Ball.contacts_reported > 0
	if not is_in_contact:
		return false
	var colliders = $Ball.get_colliding_bodies()
	for collider in colliders:
		if collider.has_method("get_velocity") and \
				$Ball.linear_velocity.round().is_equal_approx(collider.get_velocity()):
			return true
	return false

func is_still():
	var is_zero = $Ball.linear_velocity.is_equal_approx(Vector3.ZERO)
	# ensure short-circuit
	if is_zero:
		return true
	return is_on_moving_floor()

func is_position_improving():
	return $Ball.global_transform.origin.y > self.last_settled_y and \
			not self.has_worsened_this_stroke

func handle_collide(body: Node):
	if body.has_method("on_collide"):
		body.on_collide()
	if is_still():
		save_game()
		if $Ball.global_transform.origin.y > self.last_settled_y:
			$Audio/BingoHappy.play()
		elif $Ball.global_transform.origin.y < self.last_settled_y:
			$Audio/BingoSad.play()

func handle_win(body: Node):
	if body == $Ball:
		var win_card_node = get_node("/root/Root/Game/WinCard")
		win_card_node.visible = true
		win_card_node.get_node("Retry").visible = true
		if strokes > 1:
			win_card_node.get_node("Win").visible = true
		elif strokes == 1:
			win_card_node.get_node("HoleIn1").visible = true
		win_card_node.get_node("Particles").emitting = true
		if strokes < best_score or best_score == 0:
			set_best_score(strokes)
		save_game()

func _ready():
	$PreviewArrow.visible = false
	$Ball.connect("body_entered", self, "handle_collide")
	get_node("/root/Root/Game/Level/Goal").connect("body_entered", self, "handle_win")
	self.last_settled_y = $Ball.global_transform.origin.y

func _input(event):
	if is_still():
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

		if event.is_action_pressed("exit"):
			self.save_game()
			get_node("/root/Root/Menu").visible = true
			get_node("/root/Root").remove_child(get_node("/root/Root/Game"))

func _process(delta):
	if mouse_position_1 != null:
		var preview_mouse_position = get_viewport().get_mouse_position()
		if preview_mouse_position != null:
			var preview_impulse = calculate_impulse(preview_mouse_position, mouse_position_1)
			$PreviewArrow/Body.scale.y = preview_impulse.length() * arrow_size_factor
			$PreviewArrow.rotation.z = PI/2 - preview_impulse.angle()

	$HUD/HBox/Flex/VBox/ProgressMargin/ProgressSlider.value = \
			$Ball.global_transform.origin.y

	if not self.has_worsened_this_stroke and \
			$Ball.global_transform.origin.y < self.last_settled_y:
		self.has_worsened_this_stroke = true
