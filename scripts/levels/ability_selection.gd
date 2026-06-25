extends Node3D
@export var cursor: GPUParticles3D
@onready var player: CharacterBody3D = $player
var player_location: Vector3 = Vector3(0.0, 1.189, 0.466)
var player_roation: Vector3 = Vector3(0.0, 0.0, 0.0)
@onready var ability: Node3D = $Abilities/Ability
@onready var ability_2: Node3D = $Abilities/Ability2
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var on_card = false
var selected_card = 0
var viewing = false

func random(list:Array):
	return list[randi() % list.size()]

func random_type():
	if randi() % 20 > 18:
		return "Ability"
	else:
		return "Upgrade"

func random_rarity():
	var num = randi() % 100
	var rarity
	if num > 96:
		rarity = "Legendary"
	elif num > 85 and num <= 96:
		rarity = "Epic"
	elif num > 70 and num <= 85:
		rarity = "Rare"
	elif num > 45 and num <= 70:
		rarity = "Uncommon"
	elif num <= 45:
		rarity = "Common"
	else:
		rarity = "Common"
	return rarity

func random_value(rarity: String, type:String):
	if type == "Upgrade":
		var common: float = (randi_range(10, 50) / 10.0)
		var uncommon: float = (randi_range(15, 70) / 10.0)
		var rare: float = (randi_range(25, 100) / 10.0)
		var epic: float = (randi_range(45, 140) / 10.0)
		var legendary: float = (randi_range(70, 200) / 10.0)

		if rarity == "Legendary":
			return legendary + (randi_range(25, 40) / 10.0)
		elif rarity == "Epic":
			return epic + (randi_range(15, 30) / 10.0)
		elif rarity == "Rare":
			return rare + (randi_range(10, 25) / 10.0)
		elif rarity == "Uncommon":
			return uncommon + (randi_range(5, 15) / 10.0)
		else:
			return common + (randi_range(1, 10) / 10.0)

func randomize_ability():
	var rarity = random_rarity()
	ability.set_rarity(rarity)
	
	var upgrade_options = ability.selected_ability.get_upgrades()
	var abilities = ability.selected_ability.get_abilities()
	var type = random_type()
	
	ability.selected_ability.configure_new_ability(type)
	var value = random_value(rarity, type)
	
	if type == "Ability":
		var new_ability = random(abilities)
		if new_ability == "timeslow":
			value = randi_range(10, 80) / 100.0
		ability.selected_ability.set_ability_options(ability, value, (randi_range(100, 500) / 100.0))
	else:
		ability.selected_ability.set_ability_options(random(upgrade_options), value)
	ability.set_page_value(1)

	rarity = random_rarity()
	type = random_type()
	value = random_value(rarity, type)
	
	ability_2.set_rarity(rarity)
	ability_2.selected_ability.configure_new_ability(type)
	ability_2.set_rarity(rarity)
	ability_2.selected_ability.configure_new_ability(type)
	
	if type == "Ability":
		var new_ability = random(abilities)
		if new_ability == "timeslow":
			value = randi_range(10, 80) / 100.0
		ability_2.selected_ability.set_ability_options(ability, value, (randi_range(100, 500) / 100.0))
	else:
		ability_2.selected_ability.set_ability_options(random(upgrade_options), value)
	ability_2.set_page_value(2)
	
	

func _ready():
	randomize_ability()
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
	var ray := PhysicsRayQueryParameters3D.create(ray_start, ray_start + direction * 10.0)
	ray.collision_mask = 1
	var result := space_state.intersect_ray(ray)
	
	if result:
		cursor.position = result.position

func toggle_card():
	if animation_player.is_playing(): return
	print(viewing, on_card, selected_card)
	ability_2.toggle_hitbox()
	ability.toggle_hitbox()
	if not viewing:
		viewing = true
		animation_player.play("View_" + str(selected_card))
		await animation_player.animation_finished
	else:
		viewing = false
		animation_player.play("Return_" + str(selected_card))
		await animation_player.animation_finished

func select_card():
	if selected_card == 1:
		player.add_ability(ability.selected_ability)
	else:
		player.add_ability(ability_2.selected_ability)
	animation_player.play("Accept_" + str(selected_card))

func _on_ability_select(value: int) -> void:
	on_card = true
	selected_card = value

func _on_ability_unselect(value: int) -> void:
	if not viewing:
		on_card = false
		selected_card = value

func _on_click(button: int) -> void:
	if not on_card and not viewing:
		return
	if button == MOUSE_BUTTON_LEFT:
		if not viewing:
			toggle_card()
		else:
			select_card()
	elif button == MOUSE_BUTTON_RIGHT:
		toggle_card()

func get_level_type():
	return "Ability"
