extends Node2D

@onready var background_sound: AudioStreamPlayer = $BackgroundSound
@onready var sfx_player: AudioStreamPlayer = $SfxPlayer

var sounds := {
	"button_click": preload("res://assets/sounds/efects/click.mp3"),
	"button_hover": preload("res://assets/sounds/efects/hover.mp3"),
	"coin": preload("res://assets/sounds/efects/coin.mp3"),
	"coffee_ready": preload("res://assets/sounds/efects/perfect_cup.mp3")
}

func _ready() -> void:
	background_sound.play()


func toggle_music() -> void:
	if background_sound.playing:
		background_sound.stop()
	else:
		background_sound.play()


func play_sfx(sound_name: String) -> void:
	if not sounds.has(sound_name):
		push_warning("Som não encontrado: " + sound_name)
		return

	sfx_player.stream = sounds[sound_name]
	sfx_player.play()
