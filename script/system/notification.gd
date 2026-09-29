extends CanvasLayer

@onready var panel: PanelContainer = $PanelContainer
@onready var label: Label = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/Label


func show_notification(message: String, duration: float = 2.0) -> void:
	label.text = message
	
	panel.modulate.a = 0.0
	panel.position.y += 10
	
	var tween := create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(
		panel,
		"modulate:a",
		1.0,
		0.2
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		panel,
		"position:y",
		panel.position.y - 10,
		0.2
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	
	await get_tree().create_timer(duration).timeout
	
	hide_notification()


func hide_notification() -> void:
	var tween := create_tween()
	
	tween.tween_property(
		panel,
		"modulate:a",
		0.0,
		0.2
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	await tween.finished
	
	queue_free()
