extends Node2D

@export var customer_scene = preload("res://scene/customers.tscn")
@export var order_scene = preload("res://scene/order.tscn")
@onready var table: Sprite2D = $Area2D/Table
@onready var table_cards: Node2D = $TableCards
@onready var hud: CanvasLayer = $Hud
@onready var counter: Sprite2D = $Counter
@onready var return_game: Button = $TableCards/Return
@onready var customers: Node2D = $Customers
@onready var orders: Node2D = $Orders

var pending_orders: Array = []
var playing:bool = false

func _ready() -> void:
	spawn_customer()
	hud.show()
	playing = true
	table.material.set_shader_parameter("outline_enabled", false)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("asc"):
		get_tree().quit()

func spawn_customer() -> void:
	var customer := customer_scene.instantiate() as Customer
	customers.add_child(customer)

	customer.global_position = Vector2(273, 100)

	var available_recipes := RecipeDatabase.get_recipe_unlocked()

	if available_recipes.is_empty():
		return

	var recipe: RecipeData = available_recipes.pick_random()

	var order := order_scene.instantiate() as Order
	orders.add_child(order)
	order.global_position = Vector2(220, 20)
	
	order.timer_out.connect(_on_time_out_next_order)

	order.setup(recipe)

	customer.enter()
	
func deliver_order(recipe: RecipeData) -> void:
	for order in orders.get_children():
		if order.recipe == recipe:
			complete_order(order)
			return
			
func complete_order(order: Order) -> void:
	order.customer.order_received()
	order.queue_free()
	spawn_customer()
	
func _on_area_2d_mouse_entered() -> void:
	CursorManager.change_cursor("pointer")
	table.material.set_shader_parameter("outline_enabled", true)

func _on_area_2d_mouse_exited() -> void:
	CursorManager.change_cursor("default")
	table.material.set_shader_parameter("outline_enabled", false)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			table_cards.show()
			customers.hide()

func _on_go_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/menu.tscn")

func _on_return_pressed() -> void:
	customers.show()

func _on_time_out_next_order() -> void:
	for customer in customers.get_children():
		customer.queue_free()

	spawn_customer()
