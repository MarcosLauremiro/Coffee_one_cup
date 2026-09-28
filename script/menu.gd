extends Node2D

func _ready() -> void:
	print(RecipeDatabase.get_recipe_unlocked())

func _on_start_day_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/game.tscn")
