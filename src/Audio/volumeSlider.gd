extends HSlider

onready var _bus := AudioServer.get_bus_index("Master")

func _ready() -> void:
	value = db2linear(AudioServer.get_bus_volume_db(_bus))

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus, linear2db(value))
