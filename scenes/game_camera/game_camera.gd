extends Camera2D

var target_position = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	make_current()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	accuire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 10))


func accuire_target():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if !player: return
	
	target_position = player.global_position
