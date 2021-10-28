extends Button

onready var player_node = get_node("/root/Root/Game/Player")
onready var camera_node = get_node("/root/Root/Game/Camera")

func _pressed():
	var win_card_node = get_node("/root/Root/Game/WinCard")
	win_card_node.visible = false
	win_card_node.get_node("Win").visible = false
	win_card_node.get_node("HoleIn1").visible = false
	win_card_node.get_node("Retry").visible = false
	win_card_node.get_node("Particles").emitting = false

	player_node.reset()
	camera_node.translation.y = 80.0
