extends Control

@export var option_button: OptionButton

@onready var sound_controler_button: Button = $SoundControler
@onready var pre_game: Control = $PreGame
@onready var start_game: Button = $StartGame

var button_icon_sound_active: Texture2D = load("res://assets/ui/buttons/button_sound_active.png")
var button_icon_sound_disabled: Texture2D = load("res://assets/ui/buttons/button_sound_disabled.png")

var has_save: bool = false


func _ready() -> void:
	TranslationServer.set_locale("en")
	option_button.select(0)

	has_save = SaveManager.has_save()

	if has_save:
		SaveManager.load_game()
		start_game.text = tr("LOAD")
	else:
		start_game.text = tr("STR_GAME")


func _on_option_button_item_selected(index: int) -> void:
	if index == 0:
		TranslationServer.set_locale("en")
	elif index == 1:
		TranslationServer.set_locale("pt_BR")
	elif index == 2:
		TranslationServer.set_locale("es")


func _on_start_game_pressed() -> void:
	on_start_game()


func on_start_game() -> void:
	pre_game.show()
	pre_game.setup(not has_save)


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
