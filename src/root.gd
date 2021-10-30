extends Node

func _ready():
	$Menu/VBoxContainer/Control/VBox/Continue.connect( \
			"pressed", self, "load_or_create_game")
	$Menu/VBoxContainer/Control/VBox/NewGame.connect( \
			"pressed", self, "new_game")

func load_or_create_game():
	var game_scene = load("res://Game.tscn")
	var instance = game_scene.instance()
	instance.get_node("Player").load_game()
	add_child(instance)
	$Menu.visible = false

func new_game():
	var game_scene = load("res://Game.tscn")
	add_child(game_scene.instance())
	$Menu.visible = false
