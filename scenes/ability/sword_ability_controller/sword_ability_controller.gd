extends Node

const MAX_RANGE = 150

@export var sword_ability_scene: PackedScene
var damage = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null: return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) <= pow(MAX_RANGE, 2)
	)
	
	if enemies.size() == 0: return
	
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	var enemy = enemies[0] as Node2D
	var sword = sword_ability_scene.instantiate() as SwordAbility
	player.get_parent().add_child(sword)
	sword.hitbox_component.damage = damage
	
	sword.global_position = enemy.global_position
	sword.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	
	var enemy_direction = enemy.global_position - sword.global_position
	sword.rotation = enemy_direction.angle()
