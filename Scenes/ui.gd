extends Control

var expanded: bool = true
var can_click: bool = true
@onready var slide: AnimationPlayer = $slide

func move() -> void:
	if not can_click:
		return
	if expanded:
		can_click = false
		expanded = false
		slide.play("move_in")
	else:
		can_click = false
		expanded = true
		slide.play("move_out")

func _on_button_pressed() -> void:
	move()

func _on_slide_animation_finished(_anim_name: StringName) -> void:
	can_click = true
