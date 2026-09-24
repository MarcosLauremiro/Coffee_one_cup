@tool
extends CanvasLayer

@onready var label: Label = $DialogBox/TextMargin/Label

@export var text_speed := 0.1

var full_text := ""
var typing := false

signal text_finished

func show_text(new_text: String, _text_size: int = 16):
	full_text = new_text
	label.get_theme_font_size("font_size")
	label.text = ""
	typing = true

	for i in full_text.length():
		if not typing:
			break

		label.text = full_text.substr(0, i + 1)
		await get_tree().create_timer(text_speed).timeout

	label.text = full_text
	typing = false
	
	text_finished.emit()
