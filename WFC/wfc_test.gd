extends Node3D
func _ready() -> void:
	Events.connect("kill_plane_touched",reloadlevel)
	Events.connect("flag_reached",reloadlevel)
	pass
func reloadlevel() -> void:
	get_tree().call_deferred("reload_current_scene")
	pass
