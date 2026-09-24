class_name OrderManager
extends Node

@export var orders: Array[OrderData] = []

func generate_order(level: int) -> OrderData:
	var available_orders := get_available_orders(level)

	if available_orders.is_empty():
		return null

	return available_orders.pick_random()


func get_available_orders(level: int) -> Array[OrderData]:
	var available: Array[OrderData] = []

	for order in orders:
		if level >= order.min_level and level <= order.max_level:
			available.append(order)

	return available
