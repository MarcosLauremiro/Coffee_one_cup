class_name Transition
extends CanvasLayer

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label

signal transition_finished

var _is_transitioning := false

func change_scene(scene_path: String, scene_title: String = "") -> void:
	if _is_transitioning:
		return

	_is_transitioning = true

	label.text = scene_title

	animation.play("init_transition")
	await animation.animation_finished

	var error := get_tree().change_scene_to_file(scene_path)

	if error != OK:
		push_error("Falha ao trocar para a cena: %s (erro %s)" % [scene_path, error])
		_is_transitioning = false
		return

	animation.play("finish_transition")
	await animation.animation_finished

	_is_transitioning = false
	transition_finished.emit()
