extends Area2D

var normal : Texture = load("res://assets/ui/game/menu/revenue_normal.png")
var hover : Texture = load("res://assets/ui/game/menu/revenue_hover.png")

@onready var sprite: Sprite2D = $Sprite2D
@onready var revenues: CanvasLayer = $"../../Revenues"

func _on_mouse_entered() -> void:
	sprite.texture = hover
	CursorManager.change_cursor("pointer")
	MusicManager.play_sfx("button_hover")

func _on_mouse_exited() -> void:
	sprite.texture = normal

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			revenues.show()
