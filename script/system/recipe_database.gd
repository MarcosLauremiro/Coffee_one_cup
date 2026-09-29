extends Node

var recipes: Array[RecipeData] = []

signal recipe_unlocked(recipe: RecipeData)

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

func get_recipe_by_id(id: String) -> RecipeData:
	for recipe in recipes:
		if recipe.id == id:
			return recipe

	return null

func find_recipe(cards: Array[CardData]) -> RecipeData:
	for recipe in recipes:
		if recipe.ingredients.size() != cards.size():
			continue
		if _same_ingredients(recipe.ingredients, cards):
			return recipe
	return null
	
func _same_ingredients(a: Array[CardData], b: Array[CardData]) -> bool:
	var counts := {}
	for card in a:
		counts[card.id] = counts.get(card.id, 0) + 1
	for card in b:
		if not counts.has(card.id):
			return false
		counts[card.id] -= 1
		if counts[card.id] < 0:
			return false
	return true
	
func unlock_recipe(recipe: RecipeData) -> bool:
	if recipe.unlocked:
		return false
	recipe.unlocked = true
	recipe_unlocked.emit(recipe)
	return true
	
func make_card_data(recipe: RecipeData) -> CardData:
	var data := CardData.new()
	data.id = recipe.id
	data.title = recipe.name
	data.front = recipe.icon
	return data
	
func can_extend(cards: Array[CardData]) -> bool:
	for recipe in recipes:
		if recipe.ingredients.size() <= cards.size():
			continue
		if _contains_all(recipe.ingredients, cards):
			return true
	return false

func _contains_all(big: Array[CardData], small: Array[CardData]) -> bool:
	var counts := {}
	for c in big:
		counts[c.id] = counts.get(c.id, 0) + 1
	for c in small:
		if not counts.has(c.id):
			return false
		counts[c.id] -= 1
		if counts[c.id] < 0:
			return false
	return true
