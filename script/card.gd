class_name Card
extends Node2D

@onready var front: Sprite2D = $Front/Front
@onready var back: Sprite2D = $Back/Back

var data: CardData

func setup(card_data: CardData) -> void:
	data = card_data
	render()


func render() -> void:
	if data == null:
		return

	front.texture = data.front
	back.texture = data.back
