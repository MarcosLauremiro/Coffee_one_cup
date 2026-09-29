extends Control

@onready var text_dialog: CanvasLayer = $Panel/MarginContainer/VBoxContainer/TextDialog

func _ready() -> void:
	pass
	
func setup(day_one: bool) -> void:
	if day_one:
		text_dialog.show()
		text_dialog.show_text(tr("INST_PRE_GAME"), 12)
	else:
		text_dialog.hide()
		return

func _on_start_day_pressed() -> void:
	if not MenuData.on_has_recipe():
		return

	get_tree().change_scene_to_file("res://scene/game.tscn")

func _on_go_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/menu.tscn")
