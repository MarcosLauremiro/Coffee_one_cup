extends Node

var cursors: Dictionary = {}

func _ready() -> void:
	register_cursor("default", "res://assets/ui/cursor/cursor.png")
	register_cursor("pointer", "res://assets/ui/cursor/cursor.png")
	register_cursor("cut", "res://assets/ui/cursor/cursor_cut.png")

	change_cursor("default")


func register_cursor(cursor_name: String, path: String) -> void:
	var image: Image = load(path).get_image()

	image.resize(
		32,
		32,
		Image.INTERPOLATE_NEAREST
	)

	var texture := ImageTexture.create_from_image(image)

	cursors[cursor_name] = texture


func change_cursor(cursor_name: String) -> void:
	if not cursors.has(cursor_name):
		push_warning("Cursor não encontrado: " + cursor_name)
		return

	Input.set_custom_mouse_cursor(cursors[cursor_name])
