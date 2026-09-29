extends Node2D

func _on_start_day_pressed() -> void:
	if not MenuData.on_has_recipe():
		return

	SaveManager.data["menu"] = MenuData.save_menu()
	SaveManager.save_game()

	get_tree().change_scene_to_file("res://scene/game.tscn")
