extends Area2D

@export var slot: int = 0

const NORMAL: Texture = preload("res://assets/ui/game/menu/revenue_normal.png")
const HOVER: Texture = preload("res://assets/ui/game/menu/revenue_hover.png")

@onready var sprite: Sprite2D = $Sprite2D
@onready var recipe_selector: Control = $"../../Revenues/RecipeSelector"
@onready var revenues: CanvasLayer = $"../../Revenues"

func _ready() -> void:
	MenuData.menu_changed.connect(update_recipe)
	update_recipe()

func update_recipe() -> void:
	var recipe := MenuData.get_recipe(slot)
	sprite.modulate = Color.WHITE

	if recipe and recipe.icon:
		sprite.texture = recipe.icon
	else:
		sprite.texture = NORMAL

func _on_mouse_entered() -> void:
	if revenues.visible:
		return
	if MenuData.get_recipe(slot):
		sprite.modulate = Color(1.25, 1.25, 1.25) 
	else:
		sprite.texture = HOVER
	CursorManager.change_cursor("pointer")
	MusicManager.play_sfx("button_hover")

func _on_mouse_exited() -> void:
	update_recipe()
	CursorManager.change_cursor("default")

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if revenues.visible:
		return

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			recipe_selector.setup(slot)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			MenuData.remove_recipe(slot)
