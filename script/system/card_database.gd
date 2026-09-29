extends Node

var cards: Array[CardData] = []


const CARD_FILES: Array[CardData] = [
	preload("res://resources/cards/ingredients/coffee.tres"),
	preload("res://resources/cards/ingredients/chocolate.tres"),
	preload("res://resources/cards/ingredients/coffee_arabian.tres"),
	preload("res://resources/cards/ingredients/honey.tres"),
	preload("res://resources/cards/ingredients/ice.tres"),
	preload("res://resources/cards/ingredients/milk.tres"),
	preload("res://resources/cards/ingredients/milk_goat.tres"),
	preload("res://resources/cards/ingredients/orange.tres"),
	preload("res://resources/cards/ingredients/sugar.tres"),
	preload("res://resources/cards/ingredients/water.tres"),
]

func _ready() -> void:
	load_cards()
	print("Cartas carregadas: ", cards.size())
	for c in cards:
		print(c.resource_path, " | type=", c.type, " | rarity=", c.rarity)


func load_cards() -> void:
	cards.clear()
	for card in CARD_FILES:
		if card is CardData:
			cards.append(card)


func _scan_directory(path: String) -> void:
	var dir := DirAccess.open(path)

	if dir == null:
		push_error("Não foi possível abrir: " + path)
		return

	dir.list_dir_begin()

	var file_name := dir.get_next()

	while file_name != "":
		if file_name == "." or file_name == "..":
			file_name = dir.get_next()
			continue

		var full_path := path.path_join(file_name)

		if dir.current_is_dir():
			_scan_directory(full_path)

		elif file_name.ends_with(".tres") or file_name.ends_with(".tres.remap"):
			var clean_name := file_name.trim_suffix(".remap")
			var card = load(path.path_join(clean_name))
			print(clean_name, " -> ", card, " | é CardData? ", card is CardData)

			if card is CardData:
				cards.append(card)

		file_name = dir.get_next()

	dir.list_dir_end()

func get_cards_by_rarity(rarity: String) -> Array[CardData]:
	var result: Array[CardData] = []

	for card in cards:
		if card.rarity == rarity:
			result.append(card)

	return result
