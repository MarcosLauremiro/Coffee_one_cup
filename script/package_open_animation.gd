extends Node2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
const CARD_SCENE = preload("res://scene/card.tscn")
@onready var cards_container: Node2D = $"../CardsContainer"

func show_card(card_data: CardData) -> void:
	var card: Card = CARD_SCENE.instantiate()
	cards_container.add_child(card)
	card.setup(card_data)
	print(card_data)

func _on_area_2d_mouse_entered() -> void:
	CursorManager.change_cursor("cut")


func _on_area_2d_mouse_exited() -> void:
	CursorManager.change_cursor("default")

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			anim.play()
			await  anim.animation_finished
			anim.hide()
			var common_cards: Array[CardData] = []
	
			for card in CardDatabase.cards:
				if card.rarity == "common":
					common_cards.append(card)
					print(card)
					show_card(card)
			
