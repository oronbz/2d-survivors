extends CharacterBody2D

const MAX_SPEED = 40

@onready var health_component = $HealthComponent as HealthComponent


func _process(delta):
	var direction = get_direction_to_player()
	velocity = direction * MAX_SPEED
	move_and_slide()


func get_direction_to_player():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null: return Vector2.ZERO
	
	return (player.global_position - global_position).normalized()
