@tool
extends Resource
class_name CustomStats

# Use @export to make properties visible in the editor
@export var health: float = 100.0:
	get:
		return health
	set(value):
		health = maxf(0.0, value)
		
@export var armor: float = 0.0:
	get:
		return armor
	set(value):
		armor = clampf(value, 0.0, 100.0)
		
@export var level: int = 1:
	get:
		return level
	set(value):
		level = maxi(1, value)
		
@export var experience: float = 0.0:
	get:
		return experience
	set(value):
		experience = maxf(0.0, value)
		
@export var is_boss: bool = false

func _init() -> void:
	# Initialize default values
	health = 100.0
	armor = 0.0
	level = 1
	experience = 0.0
	is_boss = false

# Override property information for better editor integration
func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	
	properties.append({
		"name": "health",
		"type": TYPE_FLOAT,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0,1000,1,or_greater"
	})
	
	properties.append({
		"name": "armor",
		"type": TYPE_FLOAT,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0,100,0.5"
	})
	
	properties.append({
		"name": "level",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "1,100,1,or_greater"
	})
	
	properties.append({
		"name": "experience",
		"type": TYPE_FLOAT,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0,10000,0.1,or_greater,exp"
	})
	
	return properties

# Game logic methods
func level_up() -> void:
	level += 1
	
func take_damage(amount: float) -> float:
	var damage_reduction = armor / 100.0
	var actual_damage = amount * (1.0 - damage_reduction)
	health = maxf(0.0, health - actual_damage)
	return actual_damage

func heal(amount: float) -> void:
	health = minf(1000.0, health + amount)

# Example usage in editor:
# 1. Create new resource file: right-click in FileSystem -> New Resource -> CustomStats
# 2. Save as "enemy_stats.tres"
# 3. Edit values in Inspector
#
# Example usage in code:
#var stats = CustomStats.new()
#stats.health = 150.0
#stats.armor = 25.5
#stats.is_boss = true
#
# Save:
#ResourceSaver.save(stats, "res://resources/enemy_stats.tres")
#
# Load:
#var loaded_stats = load("res://resources/enemy_stats.tres") as CustomStats
