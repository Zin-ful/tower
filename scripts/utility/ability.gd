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

var abilities = ["timeslow", "boost"]
var upgradables = ["Max Health", "Regeneration", "Max Stamina", "Max Speed", "Jump Quanity", "Jump Height", "Wall Jump Boost Duration", "Wall Jump Speed Boost", "Wall Jump Max Speed"]

enum SpeedMod {SPRINT, WALL_JUMP_BOOST, DASH, BOOST}

func execute():
	if type == "Upgrade":
		if upgrade_choice not in upgradables:
			printerr("That is not an stat you can upgrade! " + upgrade_choice)
			return
		var player = get_parent()
		if player:
			if not player.has_method("is_player"):
				printerr("Not assigned to player!")
			player.upgrade(upgrade_choice, upgrade_amount)
		else:
			printerr("Not assigned to player!")
	else:
		if not executables.find_key(ability_choice):
			printerr("No existing ability with the name: " + ability_choice)
			return
		executables.call(ability_choice)

func get_upgrades():
	return upgradables

func get_abilities():
	return abilities

func configure_new_ability(new_type:String):
	type = new_type

func set_ability_options(new_name:String, new_value:float, new_duration:float = 0): ##New Name: A name for the ability\nNew Value: The value for either intensity (for abilities) or upgrade amounts (for upgrades)\nNew Duration: Optional but required for abilities. Auto filled to 0 (
	if type == "Ability":
		ability_choice = new_name
		intensity = new_value
		if duration > 0:
			duration = new_duration
		else:
			printerr("Type has been declared as ability. SET THE DURATION PROPERLY")
	else:
		upgrade_choice = new_name
		if upgrade_choice == "Jump Quanity":
			new_value = new_value / 10
			if new_value < 1:
				new_value = 1
		elif upgrade_choice == "Wall Jump Boost Duration":
			new_value = new_value / 10.0
			if new_value < 0.1:
				new_value = 0.1
				
		upgrade_amount = new_value
	
	print(new_name)
	print(new_value)
	print(new_duration)

func timeslow():
	Engine.time_scale = intensity
	await get_tree().create_timer(duration).timeout
	Engine.time_scale = 1.0

func boost():
	var player = get_parent()
	player.add_speed_modifier(SpeedMod.BOOST, intensity)
	await get_tree().create_timer(duration).timeout
	player.remove_speed_modifier(SpeedMod.BOOST)
