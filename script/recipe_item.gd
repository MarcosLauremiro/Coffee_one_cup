class_name RecipeItem
extends Control

signal chosen(recipe: RecipeData)

@onready var name_recipe: Label = $MarginContainer/HBoxContainer/VBoxContainer/Name
@onready var ingredients: Label = $MarginContainer/HBoxContainer/VBoxContainer/Ingredients
@onready var price: Label = $MarginContainer/HBoxContainer/HBoxContainer/Price
@onready var icon_recipe: TextureRect = $MarginContainer/HBoxContainer/TextureRect
@onready var bg: TextureRect = $Bg

const BG_HOVER: Texture = preload("res://assets/ui/game/menu/recipe_list_hover.png")
const BG_NORMAL: Texture = preload("res://assets/ui/game/menu/recipe_list.png")

var recipe_selected: RecipeData
var scroll_area: Control


func setup(recipe: RecipeData, clip_area: Control) -> void:
	recipe_selected = recipe
	scroll_area = clip_area

	name_recipe.text = recipe.name
	price.text = "$ %d" % recipe.price

	var ingredient_names: Array[String] = []
	for ingredient in recipe.ingredients:
		ingredient_names.append(ingredient.title)
	ingredients.text = " • ".join(ingredient_names)

	if recipe.icon:
		icon_recipe.texture = recipe.icon
	else:
		icon_recipe.visible = false


func _mouse_in_visible_area() -> bool:
	if not is_visible_in_tree():
		return false
	if scroll_area == null:
		return true
	return scroll_area.get_global_rect().has_point(get_global_mouse_position())


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not _mouse_in_visible_area():
		return

	if event is InputEventMouseButton and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		chosen.emit(recipe_selected)


func _on_area_2d_mouse_entered() -> void:
	if _mouse_in_visible_area():
		bg.texture = BG_HOVER


func _on_area_2d_mouse_exited() -> void:
	bg.texture = BG_NORMAL
