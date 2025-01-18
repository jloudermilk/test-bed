extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		get_viewport().mode = (
			Window.MODE_FULLSCREEN if
			get_viewport().mode != Window.MODE_FULLSCREEN else
			Window.MODE_WINDOWED
		)
func _ready() -> void:
	Events.connect("kill_plane_touched",reloadlevel)
	Events.connect("flag_reached",reloadlevel)
	for autoload in get_tree().root.get_children():
		if autoload != get_tree().get_current_scene():
			print(autoload)
	pass
func reloadlevel() -> void:
	get_tree().call_deferred("reload_current_scene")
	pass
