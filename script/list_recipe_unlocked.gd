extends Control

@onready var scroll: ScrollContainer = $Panel/MarginContainer/ScrollContainer
@onready var v_box_container: VBoxContainer = $Panel/MarginContainer/ScrollContainer/VBoxContainer

const RECIPE_ITEM_SCENE := preload("res://scene/ui/recipe_item.tscn")

var current_slot: int = -1
var _can_pick: bool = false
var _open_id: int = 0   # invalida travas de aberturas antigas


func setup(slot: int) -> void:
	current_slot = slot
	_can_pick = false
	_open_id += 1
	var my_id := _open_id

	_clear_items()
	(get_parent() as CanvasLayer).show()
	show()

	var recipes: Array[RecipeData] = RecipeDatabase.get_recipe_unlocked()

	for recipe in recipes:
		if MenuData.has_recipe(recipe):   # já está no cardápio, pula
			continue

		var item := RECIPE_ITEM_SCENE.instantiate() as RecipeItem
		v_box_container.add_child(item)
		item.setup(recipe, scroll)
		item.chosen.connect(_on_recipe_chosen)

	await get_tree().process_frame
	await get_tree().physics_frame
	await get_tree().physics_frame

	if my_id == _open_id and visible:
		_can_pick = true


func _on_recipe_chosen(recipe: RecipeData) -> void:
	if not _can_pick:
		return
	_can_pick = false   # só a primeira escolha vale

	MenuData.set_recipe(current_slot, recipe)
	close.call_deferred()


func close() -> void:
	_can_pick = false
	_open_id += 1   # cancela qualquer trava pendente
	_clear_items()
	hide()
	(get_parent() as CanvasLayer).hide()


func _clear_items() -> void:
	for child in v_box_container.get_children():
		v_box_container.remove_child(child)
		child.queue_free()


func _on_return_pressed() -> void:
	close()
