extends Control

@export var option_button: OptionButton
@onready var sound_controler_button: Button = $SoundControler

var button_icon_sound_active: Texture2D = load("res://assets/ui/buttons/button_sound_active.png")
var button_icon_sound_disabled: Texture2D = load("res://assets/ui/buttons/button_sound_disabled.png")

@onready var pre_game: Control = $PreGame
@onready var start_game: Button = $StartGame

func _ready() -> void:
	if SaveManager.has_save():
		start_game.text = tr("LOAD")
	start_game.text = tr("STR_GAME")
	option_button.select(0)
	TranslationServer.set_locale("en")

func _on_option_button_item_selected(index: int) -> void:
	if index == 0:
		TranslationServer.set_locale("en")
	if index == 1:
		TranslationServer.set_locale("pt_BR")
	if index == 2:
		TranslationServer.set_locale("es")

func _on_start_game_pressed() -> void:
	on_start_game()

func on_start_game() -> void:
	pre_game.show()
	if SaveManager.has_save():
		print("false")
		pre_game.setup(false)
	else:
		print("true")
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
		
