extends Node3D

@onready var beams: Node3D = $Beams
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var lights: Node3D = $"../Lighting"

func _ready():
	beams.visible = false

func _detect_player(body: Node3D) -> void:
	if body.has_method("is_player"):
		lights.visible = false
		beams.visible = true
		animation_player.play("Approach")
		await animation_player.animation_finished
		lights.visible = true
		queue_free()

func _detect_hitbox(body: Node3D) -> void:
	if body.has_method("is_player"):
		body.take_damage(10)
