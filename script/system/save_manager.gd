extends Node

const SAVE_PATH := "user://savegame.json"

var data := {
	"day": 1,
	"money": 0,
	"unlocked_cards": [],
	"unlocked_recipes": [],
	"upgrades": {},
	"menu": ["", "", "", "", "", ""]
}

func save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)

	if file == null:
		push_error("Não foi possível criar o save.")
		return

	file.store_string(JSON.stringify(data))
	file.close()


func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)

	if file == null:
		return false

	var content := file.get_as_text()
	file.close()

	var json := JSON.new()
	var error := json.parse(content)

	if error != OK:
		push_error("Save corrompido.")
		return false

	if typeof(json.data) != TYPE_DICTIONARY:
		push_error("Save inválido.")
		return false

	data = json.data
	MenuData.load_menu()
	MoneyManager.load_from_save()
	return true


func has_save() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)

	if file == null:
		return false

	var content := file.get_as_text()
	file.close()

	var json := JSON.new()

	if json.parse(content) != OK:
		return false

	if typeof(json.data) != TYPE_DICTIONARY:
		return false

	return true


func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
