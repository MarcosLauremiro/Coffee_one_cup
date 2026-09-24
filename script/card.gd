extends Node2D

enum CardType {
	INGREDIENT,
	RECIPE,
	EVENT
}

var type: CardType
var data: Dictionary

func setup(card_type: CardType, card_data: Dictionary) -> void:
	type = card_type
	data = card_data
	
	
