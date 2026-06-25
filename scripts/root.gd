extends Node3D
@onready var level_node: Node3D = $Level


func load_level(path: String, player):
	
	for child in level_node.get_children():
		child.queue_free()

	var level = load(path).instantiate()
	level_node.add_child(level)
	player.global_position = level.spawn_point.global_position
	player.global_rotation = level.spawn_point.global_rotation
	player.fade_to_clear()
	
func _on_goal_level_completed() -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.fade_to_black()
	load_level("res://scenes/main/AbilitySelection.tscn", player)
