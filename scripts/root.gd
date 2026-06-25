extends Node3D
@onready var level_node: Node3D = $Level
@onready var dungeon: Node3D = $Level/Dungeon
@onready var player: CharacterBody3D = $player
@onready var goal: Node3D = $Goal

func _ready() -> void:
	set_player()
	set_goal()
func set_player():
	var spawn = dungeon.get_node("SpawnPoint")
	if not spawn:
		printerr("No spawn point!!!")
	player.global_position = spawn.global_position
	player.global_rotation = spawn.global_rotation
	player.fade_to_clear()

func set_goal():
	var spawn = dungeon.get_node("GoalPoint")
	if not spawn:
		printerr("No goal spawn point!!!")
	goal.global_position = spawn.global_position
	goal.global_rotation = spawn.global_rotation

func load_level(path: String, player):
	
	for child in level_node.get_children():
		child.queue_free()

	dungeon = load(path).instantiate()
	level_node.add_child(dungeon)
	
	var spawn = dungeon.get_node("SpawnPoint")
	if not spawn:
		printerr("No spawn point!!!")
	player.global_position = spawn.global_position
	player.global_rotation = spawn.global_rotation
	if dungeon.get_level_type() == "Dungeon":
		player.fade_to_clear()
	
func _on_goal_level_completed() -> void:
	player.fade_to_black()
	load_level("res://scenes/main/AbilitySelection.tscn", player)
