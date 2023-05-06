extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}


func _ready():
	experience_manager.level_up.connect(on_level_up)


func apply_upgrade(upgrade: AbilityUpgrade):	
	var has_upgrade = current_upgrades.has(upgrade.id)
	
	if has_upgrade:
		current_upgrades[upgrade.id]["quantity"] += 1
	else:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	var upgrades = upgrade_pool.duplicate()
	for i in 2:
		upgrades.shuffle()
		var chosen_upgrade = upgrades.pop_back()
		chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)


func on_level_up(level: int):
	var upgrade_screen = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen.upgrade_selected.connect(on_upgrade_selected)
