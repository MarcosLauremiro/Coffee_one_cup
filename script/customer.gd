class_name Customer
extends Node2D

@onready var dialog_order: CanvasLayer = $DialogOrder

enum State { ENTERING, WAITING_ORDER, WAITING_FOOD, EATING, LEAVING }

var status = State.ENTERING

var order:OrderData = null

func _ready() -> void:
	dialog_order.visible = false

func update_status() -> void:
	match status:
		State.ENTERING:
			pass
		State.WAITING_ORDER:
			gerate_order()

func setup(orderDT: OrderData) -> void:
	order = orderDT
	status = State.WAITING_ORDER
	update_status()
	
func enter() -> void:
	scale = Vector2.ZERO

	var tween := create_tween()

	tween.tween_property(
		self,
		"scale",
		Vector2(1.15, 0.85),
		0.12
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		self,
		"scale",
		Vector2.ONE,
		0.1
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func gerate_order() -> void:
	dialog_order.visible = true 
	dialog_order.show_text("Um", str(order.name))
	
