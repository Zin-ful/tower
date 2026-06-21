extends Node3D

@onready var construction: Node3D = $Lazer/Construction #No change
@onready var animation_player: AnimationPlayer = get_parent().get_node("AnimationPlayer") #No change

@export var idle_animation_name = ""
@export var action_animation_name = ""


var err = 0

func _ready():
	if idle_animation_name:
		animation_player.play(idle_animation_name)

func _detect_player(body: Node3D) -> void:
	if body.has_method("is_player"):
		for ray in $DetectArea/Rays.get_children():
			if ray.is_colliding():
				var player = ray.get_collider()
				if player.has_method("is_player"):
					if action_animation_name:
						animation_player.play(action_animation_name)
						await animation_player.animation_finished
						queue_free()
