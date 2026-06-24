extends Node3D
@onready var particles: GPUParticles3D = $Particles
@export_enum("Common", "Uncommon", "Rare", "Epic", "Legendary") var rarity: String
@export var white: Color
@export var green: Color
@export var blue: Color
@export var purple: Color
@export var yellow: Color
@export var white_amount: int
@export var green_amount: int
@export var blue_amount: int
@export var purple_amount: int
@export var yellow_amount: int
@onready var page_mesh: MeshInstance3D = $Mesh
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	particles.emitting = false
	if rarity:
		set_rarity_properties()


func set_rarity(type: String):
	rarity = type
	set_rarity_properties()
	
func set_rarity_properties():
	var rarity_colors = {"Common": white, "Uncommon": green, "Rare": blue, "Epic": purple, "Legendary": yellow}
	var rarity_amounts = {"Common": white_amount, "Uncommon": green_amount, "Rare": blue_amount, "Epic": purple_amount, "Legendary": yellow_amount}
	particles.amount = rarity_amounts[rarity]
	
	var mesh = particles.draw_pass_1.duplicate()
	particles.draw_pass_1 = mesh
	var mat = mesh.material.duplicate()
	mesh.material = mat
	mat.emission = rarity_colors[rarity]
	
	var new_page_mesh = page_mesh.mesh.duplicate()
	var new_page_material = page_mesh.mesh.material.duplicate()
	page_mesh.mesh = new_page_mesh
	page_mesh.mesh.material = new_page_material
	page_mesh.mesh.material.emission = rarity_colors[rarity]

func start():
	particles.emitting = true

func stop():
	particles.emitting = false

func _mouse_entered(area: Area3D) -> void:
	print("selected!")


func _mouse_left(area: Area3D) -> void:
	print("unselected!")
