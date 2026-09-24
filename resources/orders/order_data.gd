class_name OrderData
extends Resource

@export var id: String
@export var name: String
@export var ingredients: Array[String] = []
@export var price: int = 1

@export_category("Difficulty")
@export var min_level: int = 1
@export var max_level: int = 99

@export_category("Special")
@export var is_boss: bool = false
