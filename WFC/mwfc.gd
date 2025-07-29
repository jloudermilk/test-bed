extends Node3D

@export var wfc_res: WFCResource

func _ready() -> void:
	if not wfc_res:
		wfc_res = WFCResource.new()
