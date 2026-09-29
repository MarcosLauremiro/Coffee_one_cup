extends Control

@onready var start_day: Button = $Panel/MarginContainer/VBoxContainer/StartDay
@onready var help_button: Button = $Panel/HelpButton

func _ready() -> void:
	help_button.pressed.connect(show_tutorial)

func setup(day_one: bool) -> void:
	if day_one and not TutorialData.has_seen("pre_game"):
		await show_tutorial()
		TutorialData.mark_seen("pre_game")

func show_tutorial() -> void:
	var steps := [
		{ "title": "TUT_PRE_1_TITLE", "text": "TUT_PRE_1_TEXT" },
		{ "title": "TUT_PRE_2_TITLE", "text": "TUT_PRE_2_TEXT" },
	]
	var tutorial := TutorialOverlay.open(self, steps)
	await tutorial.finished

func _on_start_day_pressed() -> void:
	if not MenuData.on_has_recipe():
		# feedback em vez de falhar em silêncio
		show_tutorial()
		return
	get_tree().change_scene_to_file("res://scene/game.tscn")

func _on_go_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/menu.tscn")
