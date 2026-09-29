extends Node

var SAVE_PATH := "user://savegame_dev.json" if OS.has_feature("editor") else "user://savegame.json"
const SETTINGS_PATH := "user://settings.cfg"

var data := _default_data()


func _default_data() -> Dictionary:
	return {
		"day": 1,
		"money": 0,
		"unlocked_cards": [],
		"unlocked_recipes": [],
		"upgrades": {},
		"menu": ["", "", "", "", "", ""],
		"tutorials": {},  # { "pre_game": true, "game": true }
	}


func _ready() -> void:
	# aplica o idioma salvo assim que o jogo abre
	var lang := get_language()
	if lang != "":
		TranslationServer.set_locale(lang)


# ---------- Idioma (arquivo separado, não conta como save) ----------
func get_language() -> String:
	var cfg := ConfigFile.new()
	if cfg.load(SETTINGS_PATH) != OK:
		return ""
	return str(cfg.get_value("general", "language", ""))


func set_language(locale: String) -> void:
	TranslationServer.set_locale(locale)
	var cfg := ConfigFile.new()
	cfg.load(SETTINGS_PATH)
	cfg.set_value("general", "language", locale)
	cfg.save(SETTINGS_PATH)


# ---------- Tutoriais ----------
func is_tutorial_done(id: String) -> bool:
	return bool(data["tutorials"].get(id, false))


func mark_tutorial_done(id: String) -> void:
	data["tutorials"][id] = true
	save_game()


# ---------- Save ----------
func _read_file() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return {}
	var content := file.get_as_text()
	file.close()

	var json := JSON.new()
	if json.parse(content) != OK:
		push_error("Save corrompido.")
		return {}
	if typeof(json.data) != TYPE_DICTIONARY:
		push_error("Save inválido.")
		return {}
	return json.data


func save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Não foi possível criar o save.")
		return
	file.store_string(JSON.stringify(data))
	file.close()


func load_game() -> bool:
	var loaded := _read_file()
	if loaded.is_empty():
		return false

	# mescla com os padrões: saves antigos ganham os campos novos
	data = _default_data()
	data.merge(loaded, true)
	if typeof(data["tutorials"]) != TYPE_DICTIONARY:
		data["tutorials"] = {}

	MenuData.load_menu()
	MoneyManager.load_from_save()
	return true


func has_save() -> bool:
	return not _read_file().is_empty()


func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
	data = _default_data()
