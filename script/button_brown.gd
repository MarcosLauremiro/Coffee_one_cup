extends Button

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

func _on_mouse_entered() -> void:
	MusicManager.play_sfx("button_hover")

func _on_pressed() -> void:
	MusicManager.play_sfx("button_click")
