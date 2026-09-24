extends CanvasLayer

@onready var text: Label = $MarginContainer/MarginContainer/HBoxContainer/Text
@onready var destaque: Label = $MarginContainer/MarginContainer/HBoxContainer/Destaque

@export var text_speed := 0.1

var typing := false

signal text_finished


func show_text(new_text: String, new_destaque: String = "") -> void:
	text.text = ""
	destaque.text = ""
	typing = true

	# Digita o texto normal
	for i in new_text.length():
		if not typing:
			break

		text.text = new_text.substr(0, i + 1)
		await get_tree().create_timer(text_speed).timeout

	# Digita o destaque depois
	for i in new_destaque.length():
		if not typing:
			break

		destaque.text = new_destaque.substr(0, i + 1)
		await get_tree().create_timer(text_speed).timeout

	typing = false
	text_finished.emit()
