class_name OpenPackage
extends Node2D

@onready var background: ColorRect = $Background
@onready var package: Node2D = $Package

@onready var area_2d_cut: Area2D = $Package/Area2D

const CARD_SCENE = preload("res://scene/card.tscn")

@onready var animated_comum: AnimatedSprite2D = $Package/AnimatedComum
@onready var animated_rare: AnimatedSprite2D = $Package/AnimatedRare
@onready var animated_epic: AnimatedSprite2D = $Package/AnimatedEpic
@onready var cards_container: Node2D = $CardsContainer
@onready var pakage_controler_comum: Package = $"../PakageControlerComum"
@onready var pakage_controler_rare: Package = $"../PakageControlerRare"
@onready var pakage_controler_epic: Package = $"../PakageControlerEpic"

@onready var table_cards: TableCards = get_parent()

var type_package_opening: Package.RarityType

var opening := false
var processing_card := false
var current_animation: AnimatedSprite2D

var package_cards: Array[CardData] = []
var collected_cards: Array[CardData] = []
var current_card: Card
var current_index := 0

func _ready() -> void:
	background.hide()
	
	pakage_controler_comum.clicked.connect(_on_package_clicked)
	pakage_controler_rare.clicked.connect(_on_package_clicked)
	pakage_controler_epic.clicked.connect(_on_package_clicked)

func setup(type: Package.RarityType) -> void:
	type_package_opening = type

	background.hide()

	animated_comum.hide()
	animated_rare.hide()
	animated_epic.hide()

	animated_comum.stop()
	animated_rare.stop()
	animated_epic.stop()

	match type:
		Package.RarityType.COMUM:
			current_animation = animated_comum
		Package.RarityType.RARE:
			current_animation = animated_rare
		Package.RarityType.EPIC:
			current_animation = animated_epic

	current_animation.show()
	current_animation.animation = "default"
	current_animation.stop()
	current_animation.frame = 0

	opening = false
	processing_card = false
	current_index = 0

	area_2d_cut.input_pickable = true
		
func _on_area_2d_input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
) -> void:

	if not event is InputEventMouseButton:
		return

	if not event.pressed:
		return

	if event.button_index != MOUSE_BUTTON_LEFT:
		return

	if opening:
		return

	opening = true

	# IMPORTANTE: resetar o cursor
	CursorManager.change_cursor("default")

	area_2d_cut.input_pickable = false

	generate_package()

	current_index = 0

	await open_package_animation()

	show_next_card()
	
func open_package_animation() -> void:
	if current_animation == null:
		return

	current_animation.stop()
	current_animation.frame = 0

	current_animation.play()

	await current_animation.animation_finished

	current_animation.hide()

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
	print(collected_cards)
	if current_index >= package_cards.size():
		finish_package()
		return

	var card_data: CardData = package_cards[current_index]

	var card: Card = CARD_SCENE.instantiate()

	cards_container.add_child(card)

	current_card = card

	card.setup(card_data)

	card.clicked.connect(_on_card_clicked)

	card.position = Vector2.ZERO

	processing_card = false
	
func finish_package() -> void:
	current_card = null
	current_index = 0
	processing_card = false
	opening = false

	animated_comum.hide()
	animated_rare.hide()
	animated_epic.hide()

	CursorManager.change_cursor("default")
	hide() 
	
func _on_card_clicked(card: Card) -> void:
	if card != current_card:
		return

	if processing_card:
		return

	processing_card = true

	# Primeiro clique: virar carta
	if not card.is_front:
		await card.flip()

		processing_card = false
		return

	# Segundo clique: coletar carta
	collected_cards.append(card.data)

	table_cards.add_collected_card(card.data)

	await card.remove_card()

	card.queue_free()

	current_card = null
	current_index += 1

	await get_tree().create_timer(0.1).timeout

	show_next_card()
	
func _on_package_clicked(card_type: Package.RarityType) -> void:
	show()
	setup(card_type)

func _on_return_pressed() -> void:
	CursorManager.change_cursor("default")

	area_2d_cut.input_pickable = true

	hide()
	
func _on_area_2d_mouse_entered() -> void:
	CursorManager.change_cursor("cut")


func _on_area_2d_mouse_exited() -> void:
	CursorManager.change_cursor("default")
	
func set_package_input(enabled: bool) -> void:
	area_2d_cut.set_process_input(enabled)
	area_2d_cut.set_process_unhandled_input(enabled)
	area_2d_cut.monitoring = enabled
	area_2d_cut.monitorable = enabled
	
func reset_package_cursor() -> void:
	CursorManager.change_cursor("default")
	
	
	
	
