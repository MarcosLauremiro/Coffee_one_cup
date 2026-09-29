class_name TableCards
extends Node2D

@onready var open_package: OpenPackage = $OpenPackage
@onready var cards: Node2D = $Cards

const CARD_SCENE = preload("res://scene/card.tscn")

func _ready() -> void:
	get_viewport().physics_object_picking_sort = true
	get_viewport().physics_object_picking_first_only = true

func add_collected_card(card_data: CardData) -> void:
	var card: Card = CARD_SCENE.instantiate()
	var index := cards.get_child_count()
	card.position = Vector2(index * 0, index * -16)
	card.draggable = true
	card.clicked.connect(_on_card_clicked)
	cards.add_child(card)
	card.setup(card_data)
	card.show_front()

func _on_card_clicked(card: Card) -> void:
	card.flip()


func get_top_card() -> Card:
	if cards.get_child_count() == 0:
		return null

	return cards.get_child(cards.get_child_count() - 1) as Card
