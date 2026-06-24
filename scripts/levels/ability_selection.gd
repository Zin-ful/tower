extends Node3D
@export var cursor: GPUParticles3D
@onready var player: CharacterBody3D = $player
var player_location: Vector3 = Vector3(0.0, 1.189, 0.466)
var player_roation: Vector3 = Vector3(0.0, 0.0, 0.0)
@onready var ability: Node3D = $Abilities/Ability
@onready var ability_2: Node3D = $Abilities/Ability2
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var rarity = ["Common", "Uncommon", "Rare", "Epic", "Legendary"]

func _ready():
	print()
	ability.set_rarity(rarity[randi() % rarity.size()])
	ability_2.set_rarity(rarity[randi() % rarity.size()])
	set_physics_process(false)
	cursor.visible = false
	player.disable_mouse()
	player.disable_movement()
	player.position = player_location
	player.rotation = player_roation
	call_deferred("_intro")
	
func _intro():
	animation_player.play("Fall")
	await player.fade_to_clear(1.5, true)
	ability.start()
	ability_2.start()
	set_physics_process(true)
	cursor.visible = true
	player.toggle_mouse()
	player.enable_mouse()
	

func _physics_process(delta: float) -> void:
	var cam := player.get_child(0).get_child(0) #Gets camera object
	var mouse = player.get_mouse()
	var ray_start: Vector3 = cam.project_ray_origin(mouse)
	var direction: Vector3 = cam.project_ray_normal(mouse)
	var space_state := get_world_3d().direct_space_state
	var ray := PhysicsRayQueryParameters3D.create(ray_start, ray_start + direction * 3.0)
	ray.collision_mask = 1
	var result := space_state.intersect_ray(ray)
	
	if result:
		cursor.position = result.position
