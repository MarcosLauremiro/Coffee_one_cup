extends Node

var cards: Array[CardData] = []

const CARDS_PATH := "res://resources/cards/"


func _ready() -> void:
	load_cards()


func load_cards() -> void:
	cards.clear()
	_scan_directory(CARDS_PATH)


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

		elif file_name.ends_with(".tres"):
			var card = load(full_path)

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
