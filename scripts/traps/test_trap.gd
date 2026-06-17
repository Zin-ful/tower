extends Node3D

@onready var damage_area: Area3D = $Spikes/DamageArea
@onready var detection_area: Area3D = $DetectionArea

func do_damage(body):
	if body.has_method("take_damage"):
		body.take_damage(10)

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _detect_player(body: Node3D) -> void:
	animation_player.play("Spring")
	await animation_player.animation_finished
	animation_player.play("Retract")
	await animation_player.animation_finished
	
func _detect_hitbox(body: Node3D) -> void:
	do_damage(body)
