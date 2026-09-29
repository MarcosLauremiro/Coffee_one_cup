extends Node

const ORDER_TIME := 30.0


func generate_order() -> RecipeData:
	var available_recipes := MenuData.get_available_recipes()

	if available_recipes.is_empty():
		return null

	return available_recipes.pick_random()
