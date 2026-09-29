extends Control

@onready var sound_controler_button: Button = $SoundControler
@onready var pre_game: Control = $PreGame
@onready var start_game: Button = $StartGame
@onready var option_button: OptionButton = $OptionButton

var button_icon_sound_active: Texture2D = load("res://assets/ui/buttons/button_sound_active.png")
var button_icon_sound_disabled: Texture2D = load("res://assets/ui/buttons/button_sound_disabled.png")

var has_save: bool = false

const LOCALES := ["en", "pt_BR", "es"]


func _ready() -> void:
	var saved := SaveManager.get_language()
	if saved == "":
		saved = "en"  # padrão no primeiro acesso
	TranslationServer.set_locale(saved)
	option_button.select(maxi(LOCALES.find(saved), 0))

	has_save = SaveManager.has_save()
	if has_save:
		SaveManager.load_game()
	_update_start_text()


func _update_start_text() -> void:
	start_game.text = tr("LOAD") if has_save else tr("STR_GAME")


func _on_option_button_item_selected(index: int) -> void:
	SaveManager.set_language(LOCALES[index])
	_update_start_text()


func _on_start_game_pressed() -> void:
	on_start_game()


func on_start_game() -> void:
	pre_game.show()
	pre_game.setup(true)


func _on_quit_game_pressed() -> void:
	get_tree().quit()


func _on_start_game_mouse_entered() -> void:
	CursorManager.change_cursor("pointer")


func _on_start_game_mouse_exited() -> void:
	CursorManager.change_cursor("default")


func _on_quit_game_mouse_entered() -> void:
	CursorManager.change_cursor("pointer")


func _on_quit_game_mouse_exited() -> void:
	CursorManager.change_cursor("default")


func _on_sound_controler_pressed() -> void:
	MusicManager.toggle_music()

	if MusicManager.music.playing:
		sound_controler_button.icon = button_icon_sound_disabled
	else:
		sound_controler_button.icon = button_icon_sound_active


func _on_credits_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/credit.tscn")
