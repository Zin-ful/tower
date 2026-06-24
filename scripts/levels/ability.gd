extends Node3D
class_name Ability

@export_group("Required Information")
@export_enum ("Ability", "Upgrade") var type: String

@export_group("Abilities")
@export_enum("timeslow", "boost") var ability_choice: String
@export var intensity: float
@export var duration: float

@export_group("Upgrades")
@export_enum("Max Health", "Regeneration", "Max Stamina","Max Speed", "Jump Quanitiy", "Jump Height", "Wall Jump Boost Duration", "Wall Jump Speed Boost") var upgrade_choice: String
@export var upgrade_amount: float

var executables = {"timeslow": timeslow, "boost": boost}
var max_health
var regen
var max_stamina
var max_speed
var jump
var jump_height
var wall_jump_duration
var wall_jump_speed_boost

var upgradables = {"Max Health": max_health, "Regeneration": regen, "Max Stamina": max_stamina, "Max Speed": max_speed, "Jump Quanitiy":jump, "Jump Height":jump_height, "Wall Jump Boost Duration":wall_jump_duration, "Wall Jump Speed Boost":wall_jump_speed_boost}

enum SpeedMod {SPRINT, WALL_JUMP_BOOST, DASH, BOOST}

func execute(type: String):
	if type == "Upgrade":
		
	else:

func set_ability_config(new_name:String, new_intensity:float, new_duration:float):
	ability_choice = new_name
	intensity = new_intensity
	duration = new_duration

func set_upgrade_config(new_name:String, new_amount:float):
	upgrade_choice = new_name
	upgrade_amount = new_amount

func upgrade():
	var player = get_parent()
	player.upgrade(upgrade_choice, upgrade_amount)

func timeslow():
	Engine.time_scale = intensity
	await get_tree().create_timer(duration).timeout
	Engine.time_scale = 1.0

func boost():
	var player = get_parent()
	player.add_speed_modifier(SpeedMod.BOOST, intensity)
	await get_tree().create_timer(duration).timeout
	player.remove_speed_modifier(SpeedMod.BOOST)
