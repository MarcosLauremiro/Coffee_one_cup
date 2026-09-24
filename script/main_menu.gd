extends Control

@export var option_button: OptionButton

func _ready() -> void:
	option_button.select(0)
	TranslationServer.set_locale("en")

func _on_option_button_item_selected(index: int) -> void:
	if index == 0:
		TranslationServer.set_locale("en")
	if index == 1:
		TranslationServer.set_locale("pt_BR")
	if index == 2:
		TranslationServer.set_locale("es")

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/day_summary.tscn")

func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _on_start_game_mouse_entered() -> void:
	CursorManager.change_cursor("pointer")


func _on_start_game_mouse_exited() -> void:
	CursorManager.change_cursor("default")


func _on_quit_game_mouse_entered() -> void:
	CursorManager.change_cursor("pointer")


func _on_quit_game_mouse_exited() -> void:
	CursorManager.change_cursor("default")
