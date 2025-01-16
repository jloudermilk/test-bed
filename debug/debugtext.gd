extends Control

@export var debugStrings = []
var RTL
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RTL =get_node("MarginContainer/RichTextLabel")

	text_test()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func text_test()->void:
		debugStrings.append("test strings")
		RTL.clear() 
		for dbgstr in debugStrings:
			RTL.append_text(dbgstr)
		pass
		
