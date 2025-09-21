extends CharacterBody2D

@export var speed: float = 400
var target_node: Node2D = null
var bullet_damage = 2

func _ready() -> void:
	target_node = _find_closest_soldier()

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(target_node):
		target_node = _find_closest_soldier()

	if is_instance_valid(target_node):
		var direction = global_position.direction_to(target_node.global_position)
		velocity = direction * speed
		rotation = direction.angle()
		move_and_slide()
	else:
		call_deferred("queue_free")

func _find_closest_soldier() -> Node2D:
	var path_spawner = get_tree().root.get_node_or_null("Map1/PathSpawner")
	if not path_spawner:
		return null
	
	var closest_soldier = null
	var closest_distance = INF
	
	# Get all soldiers in the scene tree
	var soldiers = get_tree().get_nodes_in_group("soldier")
	for soldier in soldiers:
		if soldier is Node2D:
			var distance = global_position.distance_to(soldier.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_soldier = soldier
	
	return closest_soldier

func _on_area_2d_entered(body: Node2D) -> void:
	if body.is_in_group("soldier"):
		body.health -= bullet_damage
		queue_free()
