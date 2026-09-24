extends Button

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer


func _on_mouse_entered() -> void:
	audio.play()


func _on_mouse_exited() -> void:
	pass # Replace with function body.
