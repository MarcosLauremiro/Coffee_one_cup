class_name RecipeSlot
extends PanelContainer

var recipe: RecipeData = null
var icon_rect: TextureRect


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE  # não bloqueia o clique nas cartas

	icon_rect = TextureRect.new()
	icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(icon_rect)


func is_empty() -> bool:
	return recipe == null


func set_recipe(new_recipe: RecipeData) -> void:
	recipe = new_recipe
	icon_rect.texture = new_recipe.icon if new_recipe != null else null


func clear() -> void:
	set_recipe(null)

func take() -> RecipeData:
	var taken := recipe
	clear()
	return taken
