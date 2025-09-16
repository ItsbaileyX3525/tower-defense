extends Node2D

var Bullet = preload("res://Scenes/Turrets/Missile.tscn")
var bullet_damage = 5
var path_name
var curr_targets = []
var curr

func _on_tower_radius_exited(body: Node2D) -> void:
	pass # Replace with function body.

func _on_tower_radius_entered(body: Node2D) -> void:
	if "Soldier A" in body.name:
		pass
