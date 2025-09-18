extends Node2D

var Bullet = preload("res://Scenes/Turrets/Missile.tscn")
var bullet_damage = 5
@onready var aim: Marker2D = $Turret/Marker2D
@onready var turret: Sprite2D = $Turret
var enemies_in_range = []
var curr

func _physics_process(delta: float) -> void:
	# Update current target to the enemy with most progress
	_update_current_target()
	
	if is_instance_valid(curr):
		var direction = turret.global_position.direction_to(curr.global_position)
		turret.rotation = direction.angle() + deg_to_rad(90)
	
func _update_current_target():
	# Remove invalid enemies from the list
	enemies_in_range = enemies_in_range.filter(func(enemy): return is_instance_valid(enemy))
	
	if enemies_in_range.is_empty():
		curr = null
		return
	
	# Find enemy with highest progress ratio
	var best_enemy = null
	var highest_progress = -1.0
	
	for enemy in enemies_in_range:
		if enemy.is_in_group("soldier"):
			var progress = enemy.get_parent().get_progress_ratio()
			if progress > highest_progress:
				highest_progress = progress
				best_enemy = enemy
	
	curr = best_enemy


func _on_tower_radius_entered(body: Node2D) -> void:
	if body.is_in_group("soldier"):
		enemies_in_range.append(body)
		var temp_bullet = Bullet.instantiate()
		get_node("BulletContainer").call_deferred("add_child", temp_bullet)
		temp_bullet.bullet_damage = bullet_damage
		temp_bullet.global_position = aim.global_position

func _on_tower_radius_exited(body: Node2D) -> void:
	if body.is_in_group("soldier"):
		enemies_in_range.erase(body)
