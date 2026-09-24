extends Node2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


func _on_area_2d_mouse_entered() -> void:
	CursorManager.change_cursor("cut")


func _on_area_2d_mouse_exited() -> void:
	CursorManager.change_cursor("default")

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			anim.play()
			await  anim.animation_finished
			anim.hide()
