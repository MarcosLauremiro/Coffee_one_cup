extends Node2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var cards_container: Node2D = $"../CardsContainer"
@onready var area_2d_cut: Area2D = $Area2D

const CARD_SCENE = preload("res://scene/card.tscn")

var package_cards: Array[CardData] = []
var collected_cards: Array[CardData] = []

var current_card: Card
var current_index := 0

var opening := false
var processing_card := false


func _on_area_2d_input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
) -> void:

	if event is InputEventMouseButton and event.pressed:
		if event.button_index != MOUSE_BUTTON_LEFT:
			return

		if opening:
			return

		opening = true
		anim.play()
		await anim.animation_finished
		anim.hide()
		area_2d_cut.hide()

		generate_package()

		current_index = 0

		show_next_card()


func generate_package() -> void:
	package_cards.clear()
	collected_cards.clear()

	var common_cards: Array[CardData] = []

	for card in CardDatabase.cards:
		if card.rarity == "common":
			common_cards.append(card)

	common_cards.shuffle()

	var amount: int = min(3, common_cards.size())

	for i in range(amount):
		package_cards.append(common_cards[i])


func show_next_card() -> void:

	if current_index >= package_cards.size():
		finish_package()
		return

	var card_data := package_cards[current_index]

	var card: Card = CARD_SCENE.instantiate()

	cards_container.add_child(card)

	current_card = card

	card.setup(card_data)

	card.clicked.connect(_on_card_clicked)

	card.position = Vector2.ZERO

	processing_card = false


func _on_card_clicked(card: Card) -> void:

	# Segurança
	if card != current_card:
		return

	if processing_card:
		return

	processing_card = true


	# =====================================
	# PRIMEIRO CLIQUE
	# VIRAR CARTA
	# =====================================

	if not card.is_front:

		await card.flip()

		processing_card = false

		return


	# =====================================
	# SEGUNDO CLIQUE
	# PEGAR CARTA
	# =====================================

	collected_cards.append(card.data)

	await card.remove_card()

	# Agora sim destruímos SOMENTE essa carta
	card.queue_free()

	current_card = null

	current_index += 1

	# Pequena pausa antes da próxima
	await get_tree().create_timer(0.1).timeout

	show_next_card()


func finish_package() -> void:
	print("PACOTE FINALIZADO!")

	print("Cartas recebidas:")

	for card in collected_cards:
		print(card)

	current_card = null
	current_index = 0
	processing_card = false
	opening = false

	anim.show()
	anim.frame = 0
	area_2d_cut.show()
