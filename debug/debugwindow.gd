extends Window


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to the "close_requested" signal
	connect("close_requested",_on_close_requested)
	pass # Replace with function body.

func _on_close_requested() -> void:
	queue_free() 
	pass
