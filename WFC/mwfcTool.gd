@tool
extends Resource
class_name WFCResource

var _grid_map: GridMap
var _mesh_lib: MeshLibrary

# Private variables
var _health: float = 100.0
var _armor: float = 0.0
var _level: int = 1
var _experience: float = 0.0
var _is_boss: bool = false

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	properties.append({
		"name":"_grid_map",
		"type": TYPE_OBJECT,
		"usage":PROPERTY_USAGE_DEFAULT
		})
	properties.append({
		"name":"_mesh_lib",
		"type": TYPE_OBJECT,
		"usage":PROPERTY_USAGE_DEFAULT
		})
	# Add category
	properties.append({
		"name": "Stats",
		"type": TYPE_NIL,
		"usage": PROPERTY_USAGE_CATEGORY
	})
	
	# Health property
	properties.append({
		"name": "_health",
		"type": TYPE_FLOAT,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0,1000,1,or_greater"  # Allows values over 1000
	})
	
	# Armor property
	properties.append({
		"name": "_armor",
		"type": TYPE_FLOAT,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0,100,0.5"  # 0.5 step for precise armor values
	})
	
	# Level property
	properties.append({
		"name": "_level",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "1,100,or_greater"  # Allows levels over 100
	})
	
	# Experience property
	properties.append({
		"name": "_experience",
		"type": TYPE_FLOAT,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0,10000,0.1,or_greater,exp"
	})
	
	# Boss flag property
	properties.append({
		"name": "_is_boss",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_DEFAULT
	})
	
	return properties

# Property getters
func get_health() -> float:
	return _health

func get_armor() -> float:
	return _armor

func get_level() -> int:
	return _level

func get_experience() -> float:
	return _experience

func is_boss() -> bool:
	return _is_boss

# Property setters
func set_health(value: float) -> void:
	_health = maxf(0.0, value)
	notify_property_list_changed()

func set_armor(value: float) -> void:
	_armor = clampf(value, 0.0, 100.0)
	notify_property_list_changed()

func set_level(value: int) -> void:
	_level = maxi(1, value)
	notify_property_list_changed()

func set_experience(value: float) -> void:
	_experience = maxf(0.0, value)
	notify_property_list_changed()

func set_boss(value: bool) -> void:
	_is_boss = value
	notify_property_list_changed()

# Custom methods
func level_up() -> void:
	_level += 1
	notify_property_list_changed()
	
func take_damage(amount: float) -> float:
	var damage_reduction = _armor / 100.0
	var actual_damage = amount * (1.0 - damage_reduction)
	_health = maxf(0.0, _health - actual_damage)
	notify_property_list_changed()
	return actual_damage

func heal(amount: float) -> void:
	_health = minf(1000.0, _health + amount)
	notify_property_list_changed()

# Example usage:
#var stats = CustomStats.new()
#stats.set_health(150.0)
#stats.set_armor(25.5)
#stats.set_boss(true)
#
# Save the resource:
#ResourceSaver.save(stats, "res://resources/enemy_stats.tres")
#
# Load the resource:
#var loaded_stats = load("res://resources/enemy_stats.tres") as CustomStats
