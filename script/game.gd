extends Node2D

@export var customer_scene = preload("res://scene/customers.tscn")
@onready var order_manager: OrderManager = $OrderManager
@onready var start_day: Button = $PreGame/StartDay
@onready var table: Sprite2D = $Area2D/Table
@onready var table_cards: Node2D = $TableCards
@onready var hud: CanvasLayer = $Hud
@onready var pre_game: Node2D = $PreGame
@onready var counter: Sprite2D = $Counter
@onready var return_game: Button = $TableCards/Return
@onready var customers: Node2D = $Customers

var pending_orders: Array = []
var playing:bool = false

func _ready() -> void:
	table.material.set_shader_parameter("outline_enabled", false)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("asc"):
		get_tree().quit()

func spawn_customer() -> void:
	var customer := customer_scene.instantiate() as Customer
	customers.add_child(customer)

	customer.global_position = Vector2(273, 100)

	customer.enter()
	
	await get_tree().create_timer(0.5).timeout
	var order = order_manager.generate_order(1)
	customer.setup(order)
	
func _on_start_day_pressed() -> void:
	if !playing:
		hud.show()
		spawn_customer()
		playing = true
	start_day.hide()
	pre_game.hide()
	
func _on_area_2d_mouse_entered() -> void:
	table.material.set_shader_parameter("outline_enabled", true)


func _on_area_2d_mouse_exited() -> void:
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
