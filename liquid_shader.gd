extends MeshInstance3D

@onready var material = get_surface_override_material(0) as ShaderMaterial
@export var fill_level: float = 0.5
@export var wobble_strength: float = 1.0

var time_accumulator: float = 0.0

func _ready():
	if material:
		# Set initial fill level
		material.set_shader_parameter("fill_amount", Vector3(0, fill_level, 0))

func _process(delta):
	if material:
		# Accumulate time manually
		time_accumulator += delta
		
		# Add wobble based on accumulated time
		var wobble_x = sin(time_accumulator * 2.0) * wobble_strength
		var wobble_z = cos(time_accumulator * 1.5) * wobble_strength
		
		material.set_shader_parameter("wobble_x", wobble_x)
		material.set_shader_parameter("wobble_z", wobble_z)
