extends Node3D

@onready var beams: Node3D = $Lazer/Beams
@onready var animation_player: AnimationPlayer = get_parent().get_node("AnimationPlayer") 
@onready var lights: Node3D = get_parent().get_node("Lighting")
var err = 0

func _ready():
	if not lights:
		printerr("No lights in scene! Disabling light turn off")
		err = 1
	if not animation_player:
		printerr("No Anim Player in scene! Functionality will break!")
		err = 1
	if err:
		printerr("Please check your specifications! This scene does not appear to be compliant!")
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
