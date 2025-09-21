extends CharacterBody2D

@export var speed = 50
var health = 10

func _ready() -> void:
	add_to_group("soldier")

func _process(delta: float) -> void:
	get_parent().set_progress(get_parent().get_progress() + speed * delta)
	if get_parent().get_progress_ratio() == 1:
		queue_free()

	if health <= 0:
		Game.money += 20
		get_parent().get_parent().queue_free()
