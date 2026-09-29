class_name TableCards
extends Node2D

@onready var open_package: OpenPackage = $OpenPackage
@onready var cards: Node2D = $Cards

const CARD_SCENE = preload("res://scene/card.tscn")

@onready var slots_box: HBoxContainer = $"../SlotItens/HBoxContainer"
@onready var slot_1: PanelContainer = $"../SlotItens/HBoxContainer/Slot1"
@onready var slot_2: PanelContainer = $"../SlotItens/HBoxContainer/Slot2"
@onready var slot_3: PanelContainer = $"../SlotItens/HBoxContainer/slot3"
@onready var trash: Area2D = $Trash

const CRAFT_DELAY := 0.5

const SPAWN_ORIGIN := Vector2(40, 50) 
const SPAWN_SPACING := Vector2(44, 60)
const SPAWN_COLUMNS := 8
const SPAWN_ROWS := 3
const STACK_TOLERANCE := Vector2(6, 26)

const PLAY_AREA := Rect2(Vector2(8, 8), Vector2(600, 300))

func _ready() -> void:
	get_viewport().physics_object_picking_sort = true
	get_viewport().physics_object_picking_first_only = true
	trash.input_pickable = false

func add_collected_card(card_data: CardData) -> void:
	_spawn_card(card_data, _find_free_spawn_position())

func _find_free_spawn_position() -> Vector2:
	for i in SPAWN_COLUMNS * SPAWN_ROWS:
		var pos := SPAWN_ORIGIN + Vector2((i % SPAWN_COLUMNS) * SPAWN_SPACING.x,(i / SPAWN_COLUMNS) * SPAWN_SPACING.y)
		if not _is_spot_taken(pos):
			return pos

	return SPAWN_ORIGIN + Vector2(randf_range(0, 16), randf_range(0, 16))


func _is_spot_taken(pos: Vector2) -> bool:
	for child in cards.get_children():
		var card := child as Card
		if card == null or card.is_removing:
			continue
		if absf(card.position.x - pos.x) < SPAWN_SPACING.x * 0.5 \
		and absf(card.position.y - pos.y) < SPAWN_SPACING.y * 0.5:
			return true
	return false

func _spawn_card(card_data: CardData, pos: Vector2, recipe: RecipeData = null) -> Card:
	var card: Card = CARD_SCENE.instantiate()
	card.position = pos
	card.draggable = true
	card.recipe = recipe
	card.clicked.connect(_on_card_clicked)
	card.stacked.connect(_on_card_stacked)
	card.dropped.connect(_on_card_dropped)
	cards.add_child(card)
	card.setup(card_data)
	card.show_front()
	return card
	
func get_card_stack(start: Card) -> Array[Card]:
	var stack: Array[Card] = [start]
	var i := 0
	while i < stack.size():
		var current := stack[i]
		for child in cards.get_children():
			var other := child as Card
			if other == null or other.is_removing or stack.has(other):
				continue
			var d := (other.global_position - current.global_position).abs()
			if d.x <= STACK_TOLERANCE.x and d.y <= STACK_TOLERANCE.y:
				stack.append(other)
		i += 1
	return stack
	
func _on_card_stacked(card: Card) -> void:
	# Espera um pouco pro jogador poder soltar mais uma carta na pilha
	await get_tree().create_timer(CRAFT_DELAY).timeout
	if not is_instance_valid(card) or card.is_removing or card.is_dragging:
		return

	_try_craft(card, false)

func _craft(recipe: RecipeData, stack: Array[Card]) -> void:
	# Posição do resultado = média da pilha
	var pos := Vector2.ZERO
	for c in stack:
		pos += c.position
	pos /= stack.size()

	for c in stack:
		c.remove_card()
	await get_tree().create_timer(0.25).timeout
	for c in stack:
		c.queue_free()

	var is_new := RecipeDatabase.unlock_recipe(recipe)
	_spawn_card(RecipeDatabase.make_card_data(recipe), pos, recipe)

	if is_new:
		pass

func _on_card_clicked(card: Card) -> void:
	if _try_craft(card, true):
		return
	card.flip()

func _try_craft(card: Card, forced: bool) -> bool:
	var stack := get_card_stack(card)
	if stack.size() < 2:
		return false

	var datas: Array[CardData] = []
	for c in stack:
		if c.recipe != null:
			return false  # carta de receita não é ingrediente
		datas.append(c.data)

	var recipe := RecipeDatabase.find_recipe(datas)
	if recipe == null:
		return false
	if not forced and RecipeDatabase.can_extend(datas):
		return false  # ainda dá pra adicionar cartas: espera o clique

	_craft(recipe, stack)
	return true

func get_top_card() -> Card:
	if cards.get_child_count() == 0:
		return null

	return cards.get_child(cards.get_child_count() - 1) as Card

func _on_card_dropped(card: Card) -> void:
	if card.is_flipping or card.is_removing:
		return

	if _is_over_trash(card.get_global_mouse_position()):
		_throw_away(card)
		return

	if card.recipe != null:
		var slot := _get_slot_under_mouse()
		if slot != null and slot.is_empty():
			slot.set_recipe(card.recipe)
			await card.remove_card()
			card.queue_free()
			return

	card.position = card.position.clamp(PLAY_AREA.position, PLAY_AREA.end)


func _get_slot_under_mouse() -> RecipeSlot:
	var mouse := get_viewport().get_mouse_position()
	for child in slots_box.get_children():
		var slot := child as RecipeSlot
		if slot != null and slot.get_global_rect().has_point(mouse):
			return slot
	return null
	
func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	if not (event is InputEventMouseButton):
		return
	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return

	var slot := _get_slot_under_mouse()
	if slot == null or slot.is_empty():
		return

	get_viewport().set_input_as_handled()

	var taken_recipe := slot.take()
	var card := _spawn_card(RecipeDatabase.make_card_data(taken_recipe), Vector2.ZERO, taken_recipe)
	card.global_position = card.get_global_mouse_position()
	card.start_drag()

func _is_over_trash(world_pos: Vector2) -> bool:
	var query := PhysicsPointQueryParameters2D.new()
	query.position = world_pos
	query.collide_with_areas = true
	query.collide_with_bodies = false

	for hit in get_world_2d().direct_space_state.intersect_point(query):
		if hit.collider == trash:
			return true
	return false

func _throw_away(card: Card) -> void:
	await card.remove_card()
	card.queue_free()
	
