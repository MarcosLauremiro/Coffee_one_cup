extends Node

var recipes: Array[RecipeData] = []

const RECIPE_PATH := "res://resources/recipe/"

func _ready() -> void:
	load_recipe()

func load_recipe() -> void:
	recipes.clear()
	_scan_directory(RECIPE_PATH)

func _scan_directory(path: String) -> void:
	var dir := DirAccess.open(path)

	if dir == null:
		push_error("Não foi possível abrir: " + path)
		return

	dir.list_dir_begin()

	var file_name := dir.get_next()

	while file_name != "":
		if file_name == "." or file_name == "..":
			file_name = dir.get_next()
			continue

		var full_path := path.path_join(file_name)

		if dir.current_is_dir():
			_scan_directory(full_path)

		elif file_name.ends_with(".tres"):
			var recipe = load(full_path)

			if recipe is RecipeData:
				recipes.append(recipe)

		file_name = dir.get_next()

	dir.list_dir_end()

func get_recipe_unlocked() -> Array[RecipeData]:
	var result: Array[RecipeData] = []

	for recipe in recipes:
		if recipe.unlocked == true:
			result.append(recipe)

	return result
