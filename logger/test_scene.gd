extends Node3D

var time =0.0
var logger
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	logger = get_node("DebugWindow")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	logger.custom_logger.emit("test","INFO : " + String.num(time))
	pass
