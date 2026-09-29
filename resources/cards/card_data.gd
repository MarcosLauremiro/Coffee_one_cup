class_name CardData
extends Resource

@export var id: String
@export var title: String
@export_multiline var description: String
@export var weight: int = 0

@export var front: Texture2D
@export var back: Texture2D

@export_enum("ingredient", "recipe", "event")
var type: String = "ingredient"

@export_enum("common", "rare", "epic")
var rarity: String = "common"


@export var price: int = 0
