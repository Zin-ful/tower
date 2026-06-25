extends Node3D

@onready var visual: MeshInstance3D = $Visual

func _ready() -> void:
	visual.visible = false
