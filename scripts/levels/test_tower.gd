extends Node3D
@onready var detect_one: Area3D = $DetectOne
@onready var detect_two: Area3D = $DetectTwo
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var one_trigged = 0
var two_trigged = 0
func _player_entered_one(body: Node3D) -> void:
	if body.has_method("is_player") and not one_trigged:
		animation_player.play("lower_1")
		one_trigged = 1

		
func _player_entered_two(body: Node3D) -> void:
	if body.has_method("is_player") and not two_trigged:
		animation_player.play("lower_2")
		two_trigged = 1
