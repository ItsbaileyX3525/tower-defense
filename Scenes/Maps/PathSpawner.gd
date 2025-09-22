extends Node2D

const PATH_1 = preload("uid://bff3p6b74pncw")
const SOLDIER_A = preload("uid://ddsncyxx1r0lf")
@onready var map_1: Node2D = $".."

var health_modifier = 1.0

func _on_timer_timeout() -> void:
	var temp_path = PATH_1.instantiate()
	var rng = randi_range(0,1)
	var soldier = SOLDIER_A.instantiate()
	if rng == 0:
		temp_path.get_child(0, true).add_child(soldier)
	else:
		temp_path.get_child(1, true).get_child(0, true).add_child(soldier)
	add_child(temp_path)
	map_1.left_to_spawn -= 1
