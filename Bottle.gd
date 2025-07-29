#Bottle.gd
@tool
extends MeshInstance3D

@export var fill_amount : float: get = get_fill_amount, set = set_fill_amount # (float, 0.0, 1.0)

@export var glass_color : Color: get = get_glass_color, set = set_glass_color
@export var glass_glow_color : Color: get = get_glass_glow_color, set = set_glass_glow_color

@export var glass_thickness : float: get = get_glass_thickness, set = set_glass_thickness

@export var liquid_color : Color: get = get_liquid_color, set = set_liquid_color
@export var liquid_glow_color : Color: get = get_liquid_glow_color, set = set_liquid_glow_color

@export var container_height : float: get = get_container_height, set = set_container_height
@export var container_width : float: get = get_container_width, set = set_container_width

@export var wave_intensity : float: get = get_wave_intensity, set = set_wave_intensity

@export var bottle_label : Texture2D: get = get_bottle_label, set = set_bottle_label

@export var dampening : float = 3.0
@export var spring_constant : float = 200.0
@export var reaction : float = 4.0


var coeff : Vector2
var coeff_old : Vector2
var coeff_old_old : Vector2

@onready var pos : Vector3 = to_global(position)
@onready var pos_old : Vector3 = pos
@onready var pos_old_old : Vector3 = pos_old

@onready var material_pass_1
@onready var material_pass_2
@onready var material_pass_3
@onready var material_pass_4

var accell : Vector2

func set_fill_amount(p_fill_amount : float):
	if is_inside_tree():
		material_pass_2.set_shader_parameter("fill_amount", p_fill_amount)
		material_pass_3.set_shader_parameter("fill_amount", p_fill_amount)

func get_fill_amount() -> float:
	return material_pass_2.get_shader_parameter("fill_amount")

func set_glass_color(p_color : Color):
	if is_inside_tree():
		material_pass_1.set_shader_parameter("glass_color", p_color)

func get_glass_color() -> Color:
	return material_pass_1.get_shader_parameter("glass_color")

func set_glass_glow_color(p_color : Color):
	if is_inside_tree():
		material_pass_1.set_shader_parameter("glint_color", p_color)

func get_glass_glow_color() -> Color:
	return material_pass_1.get_shader_parameter("glint_color")

func set_glass_thickness(p_thickness : float):
	if is_inside_tree():
		material_pass_2.set_shader_parameter("glass_thickness", p_thickness)
		material_pass_3.set_shader_parameter("glass_thickness", p_thickness)

func get_glass_thickness() -> float:
	return material_pass_2.get_shader_parameter("glass_thickness")

func set_liquid_color(p_color : Color):
	if is_inside_tree():
		material_pass_2.set_shader_parameter("liquid_color", p_color)
		material_pass_3.set_shader_parameter("liquid_color", p_color)

func get_liquid_color() -> Color:
	return material_pass_2.get_shader_parameter("liquid_color")

func set_liquid_glow_color(p_color : Color):
	if is_inside_tree():
		material_pass_2.set_shader_parameter("glow_color", p_color)
		material_pass_3.set_shader_parameter("glow_color", p_color)

func get_liquid_glow_color() -> Color:
	return material_pass_2.get_shader_parameter("glow_color")

func set_container_height(p_height : float):
	if is_inside_tree():
		material_pass_2.set_shader_parameter("height", p_height)
		material_pass_3.set_shader_parameter("height", p_height)

func get_container_height() -> float:
	return material_pass_2.get_shader_parameter("height")

func set_bottle_label(p_texture : Texture2D):
	if is_inside_tree():
		material_pass_4.set_shader_parameter("label_tex", p_texture)

func get_bottle_label() -> Texture2D:
	return material_pass_4.get_shader_parameter("label_tex")

func set_container_width(p_width : float):
	if is_inside_tree():
		material_pass_2.set_shader_parameter("width", p_width)
		material_pass_3.set_shader_parameter("width", p_width)

func get_container_width() -> float:
	return material_pass_2.get_shader_parameter("width")

func set_wave_intensity(p_intensity : float):
	if is_inside_tree():
		material_pass_2.set_shader_parameter("wave_intensity", p_intensity)
		material_pass_3.set_shader_parameter("wave_intensity", p_intensity)

func get_wave_intensity() -> float:
	return material_pass_2.get_shader_parameter("wave_height")

func _ready():
	var mat = get_surface_override_material(0).duplicate()
	set_surface_override_material(0, mat)

	material_pass_1 = get_surface_override_material(0)
	material_pass_1.next_pass = material_pass_1.next_pass.duplicate()
	material_pass_2 = material_pass_1.next_pass
	material_pass_2.next_pass = material_pass_2.next_pass.duplicate()
	material_pass_3 = material_pass_2.next_pass
	material_pass_3.next_pass = material_pass_3.next_pass.duplicate()
	material_pass_4 = material_pass_3.next_pass

func _physics_process(delta):
	var accell_3d = (pos - 2 * pos_old + pos_old_old) / delta / delta
	pos_old_old = pos_old
	pos_old = pos
	pos = to_global(position)

	accell = Vector2(accell_3d.x, accell_3d.z)

	coeff_old_old = coeff_old
	coeff_old = coeff
	coeff = delta*delta* (-spring_constant*coeff_old - reaction*accell) + 2 * coeff_old - coeff_old_old - delta * dampening * (coeff_old - coeff_old_old)

	material_pass_2.set_shader_parameter("coeff", coeff)
	material_pass_3.set_shader_parameter("coeff", coeff)

	material_pass_2.set_shader_parameter("vel", (coeff - coeff_old) / delta)
