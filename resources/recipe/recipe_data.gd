class_name RecipeData
extends Resource

@export_category("Informações")
@export var id: String
@export var name: String
@export_multiline var description: String

@export_category("Ingredientes")
@export var ingredients: Array[CardData]

@export_category("Resultado")
@export var price: int = 0

@export_category("Progressão")
@export var unlock_day: int = 1
@export var unlocked: bool = false

@export_category("Visual")
@export var icon: Texture2D
