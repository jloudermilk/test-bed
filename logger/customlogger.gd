extends Window

#Key value is a string you could use a hash from the stack location or 
#whatever you want
#Format Key string; log will parse INFO, ERROR, and TEST to see if in the log
# string and add colors to the strings
signal custom_logger(key:String,log:String)
@export var loggerStrings = {}
var RTL
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to the "close_requested" signal
	RTL = get_node("LoggerTextPanel/MarginContainer/RichTextLabel")
	connect("close_requested",_on_close_requested)
	connect("custom_logger",process_log)
	pass # Replace with function body.

func _on_close_requested() -> void:
	queue_free() 
	pass
	
func process_log(key:String,logs:String) -> void:
	if logs.contains("INFO"):
		logs = logs.replace("INFO", "[color=green]INFO[/color]" )
	if logs.contains("INFO"):
		logs = logs.replace("ERROR", "[color=red]ERROR[/color]" )
	if logs.contains("INFO"):
		logs = logs.replace("TEST", "[color=yellow]TEST[/color]" )	
	loggerStrings[key] = logs
	RTL.clear() 
	for logstr in loggerStrings.values():
		if logstr != null:
			RTL.append_text(logstr)
	pass
	
