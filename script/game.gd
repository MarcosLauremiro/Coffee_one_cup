extends Node2D

signal table_opened
signal order_delivered

@export var customer_scene = preload("res://scene/customers.tscn")
@export var order_scene = preload("res://scene/order.tscn")
@onready var table: Sprite2D = $Area2D/Table
@onready var table_cards: Node2D = $TableCards
@onready var hud: CanvasLayer = $Hud
@onready var counter: Sprite2D = $Counter
@onready var return_game: Button = $TableCards/Return
@onready var customers: Node2D = $Customers
@onready var orders: Node2D = $Orders
@onready var slots_box: HBoxContainer = $SlotItens/HBoxContainer
var in_tutorial := false

const CARD_SCENE := preload("res://scene/card.tscn")
const DELIVERY_RADIUS := 60.0

var delivery_cards: Node2D

var pending_orders: Array = []
var playing:bool = false

func _ready() -> void:
	delivery_cards = Node2D.new()
	add_child(delivery_cards)

	spawn_customer()
	hud.show()
	playing = true
	table.material.set_shader_parameter("outline_enabled", false)
	hud.end_timer.connect(finish_day)

	if not TutorialData.has_seen("game"):
		_start_tutorial()
		
func _start_tutorial() -> void:
	in_tutorial = true
	var pack_ctrl = table_cards.get_node("PakageControlerComum")
	
	var steps := [
		{ "title": "TUT_GAME_1_TITLE", "text": "TUT_GAME_1_TEXT",   # clique na mesa
		  "target": table, "wait": table_opened },
		{ "title": "TUT_GAME_2_TITLE", "text": "TUT_GAME_2_TEXT",       # pegar o pacote
		  "target": pack_ctrl, "wait": pack_ctrl.clicked },
		{ "title": "TUT_GAME_3_TITLE", "text": "TUT_GAME_3_TEXT",       # cortar o pacote
		  "wait": table_cards.pack_cut },
		{ "title": "TUT_GAME_CARD_TITLE", "text": "TUT_GAME_CARD_TEXT", # clicar na carta
		  "wait": table_cards.card_collected },
		{ "title": "TUT_GAME_4_TITLE", "text": "TUT_GAME_4_TEXT",       # empilhar e preparar
		  "wait": table_cards.recipe_prepared },
		{ "title": "TUT_GAME_5_TITLE", "text": "TUT_GAME_5_TEXT",   # arrastar receita pro slot
		  "target": slots_box, "wait": table_cards.recipe_stored },
		{ "title": "TUT_GAME_6_TITLE", "text": "TUT_GAME_6_TEXT",   # voltar para a loja
		  "target": return_game, "wait": return_game.pressed },
		{ "title": "TUT_GAME_7_TITLE", "text": "TUT_GAME_7_TEXT",   # arrastar pro cliente
		  "target": slots_box, "wait": order_delivered },
	]
	var tutorial := TutorialOverlay.open(hud, steps)
	table_cards.recipe_stored.connect(_on_tutorial_recipe_stored)
	await tutorial.finished
	in_tutorial = false
	table_cards.recipe_stored.disconnect(_on_tutorial_recipe_stored)
	TutorialData.mark_seen("game")
	
func _on_tutorial_recipe_stored(recipe: RecipeData) -> void:
	# No tutorial, o cliente pede exatamente a receita que o jogador craftou
	for c in customers.get_children(): c.queue_free()
	for o in orders.get_children(): o.queue_free()
	spawn_customer(recipe)

func spawn_customer(forced_recipe: RecipeData = null) -> void:
	var recipe := forced_recipe
	if recipe == null:
		var available_recipes := RecipeDatabase.get_recipe_unlocked()
		if available_recipes.is_empty():
			return  # agora não cria cliente órfão
		recipe = available_recipes.pick_random()

	var customer := customer_scene.instantiate() as Customer
	customers.add_child(customer)
	customer.global_position = Vector2(273, 100)

	var order := order_scene.instantiate() as Order
	orders.add_child(order)
	order.global_position = Vector2(220, 20)
	order.timer_out.connect(_on_time_out_next_order)
	order.setup(recipe)
	order.customer = customer
	customer.enter()
	
func try_deliver(recipe: RecipeData, drop_position: Vector2) -> bool:
	print("orders: ", orders.get_child_count(), " recipe do card: ", recipe)
	
	for order in orders.get_children():
		print("  pedido: ", order.recipe, " cliente válido: ", is_instance_valid(order.customer))
		if order.recipe != recipe:
			continue

		var customer = order.customer
		if not is_instance_valid(customer):
			continue
		if customer.global_position.distance_to(drop_position) > DELIVERY_RADIUS:
			continue

		complete_order(order)
		return true

	return false
			
func complete_order(order: Order) -> void:
	MoneyManager.make_money(order.recipe.price)
	order.customer.order_received()
	order.queue_free()
	order_delivered.emit()

	await get_tree().create_timer(0.5).timeout
	spawn_customer()
	
func _input(event: InputEvent) -> void:
	if table_cards.is_visible_in_tree():
		return  # na mesa, quem trata o slot é a TableCards
	if not (event is InputEventMouseButton):
		return
	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return

	var slot := _get_slot_under_mouse()
	if slot == null or slot.is_empty():
		return

	get_viewport().set_input_as_handled()

	var recipe := slot.take()
	var card: Card = CARD_SCENE.instantiate()
	card.draggable = true
	card.recipe = recipe
	card.dropped.connect(_on_delivery_card_dropped.bind(slot))
	delivery_cards.add_child(card)
	card.setup(RecipeDatabase.make_card_data(recipe))
	card.show_front()
	card.global_position = card.get_global_mouse_position()
	card.start_drag()


func _on_delivery_card_dropped(card: Card, origin: RecipeSlot) -> void:
	var recipe := card.recipe

	if not try_deliver(recipe, card.global_position):
		var target := _get_slot_under_mouse()
		if target == null or not target.is_empty():
			target = origin
		target.set_recipe(recipe)

	# Sempre consome a carta: ela virou entrega ou voltou pra um slot
	await card.remove_card()
	card.queue_free()


func _get_slot_under_mouse() -> RecipeSlot:
	var mouse := get_viewport().get_mouse_position()
	for child in slots_box.get_children():
		var slot := child as RecipeSlot
		if slot != null and slot.get_global_rect().has_point(mouse):
			return slot
	return null
	
func _on_area_2d_mouse_entered() -> void:
	CursorManager.change_cursor("pointer")
	table.material.set_shader_parameter("outline_enabled", true)

func _on_area_2d_mouse_exited() -> void:
	CursorManager.change_cursor("default")
	table.material.set_shader_parameter("outline_enabled", false)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			table_cards.process_mode = Node.PROCESS_MODE_INHERIT
			table_cards.show()
			table_opened.emit()

func _on_return_pressed() -> void:
	table_cards.hide()
	table_cards.process_mode = Node.PROCESS_MODE_DISABLED

func _on_go_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/menu.tscn")

func _on_time_out_next_order() -> void:
	for customer in customers.get_children():
		customer.queue_free()
	for order in orders.get_children():
		order.queue_free()
	spawn_customer()

func finish_day() -> void:
	SaveManager.data["money"] = MoneyManager.money
	SaveManager.data["day"] = int(SaveManager.data["day"]) + 1
	SaveManager.save_game()
	get_tree().change_scene_to_file("res://scene/day_summary.tscn")
