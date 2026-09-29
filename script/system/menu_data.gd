extends Node

signal menu_changed

const MAX_SLOTS := 6

var recipes: Array[RecipeData] = []


func _ready() -> void:
	recipes.resize(MAX_SLOTS)

func set_recipe(slot: int, recipe: RecipeData) -> void:
	if slot < 0 or slot >= MAX_SLOTS:
		return

	# opcional: se a receita já está em outro slot, tira de lá (ex: Espresso no slot 1 vai pro slot 4)
	var old_slot := recipes.find(recipe)
	if recipe != null and old_slot != -1 and old_slot != slot:
		recipes[old_slot] = null

	recipes[slot] = recipe
	menu_changed.emit()

func remove_recipe(slot: int) -> void:
	if slot < 0 or slot >= MAX_SLOTS:
		return

	recipes[slot] = null
	menu_changed.emit()

func get_recipe(slot: int) -> RecipeData:
	if slot < 0 or slot >= MAX_SLOTS:
		return null

	return recipes[slot]
	
func has_recipe(recipe: RecipeData) -> bool:
	for r in recipes:
		if r != null and r.id == recipe.id:
			return true
	return false

func get_available_recipes() -> Array[RecipeData]:
	var available: Array[RecipeData] = []

	for recipe in recipes:
		if recipe != null:
			available.append(recipe)

	return available

func on_has_recipe() -> bool:
	for recipe in recipes:
		if recipe != null:
			return true

	return false

func save_menu() -> Array:
	var saved_menu: Array = []

	for recipe in recipes:
		if recipe != null:
			saved_menu.append(recipe.id)
		else:
			saved_menu.append("")

	return saved_menu

func load_menu() -> void:
	recipes.clear()
	recipes.resize(MAX_SLOTS)

	if not SaveManager.data.has("menu"):
		return

	var saved_menu = SaveManager.data["menu"]

	if not saved_menu is Array:
		return

	for i in range(min(saved_menu.size(), MAX_SLOTS)):
		var recipe_id: String = str(saved_menu[i])

		if recipe_id.is_empty():
			continue

		var recipe := RecipeDatabase.get_recipe_by_id(recipe_id)

		if recipe != null:
			recipes[i] = recipe

	menu_changed.emit()
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
