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
