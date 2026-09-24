class_name DaySummary
extends Node2D

@onready var text_dialog: CanvasLayer = $TextDialog
@onready var button_next_day: Button = $ButtonNextDay

var game := "res://scene/game.tscn"
var day_one := false

func _ready() -> void:
	setup()
	
func setup() -> void:
	if day_one:
		text_dialog.show()
		text_dialog.show_text(tr("PRE_DAY_ONE"), 24)
		text_dialog.text_finished.connect(_on_finish_text)
		button_next_day.visible = false
		await get_tree().create_timer(1.0)
		button_next_day.text = tr("OPPEN_COFFEE_SHOP")
		
	button_next_day.text = tr("OPPEN_COFFEE_SHOP")
	await get_tree().create_timer(1.0)
	button_next_day.text = tr("Proximo dia")
	
func _on_finish_text() -> void:
	await get_tree().create_timer(0.5).timeout
	button_next_day.visible = true


func _on_button_next_day_pressed() -> void:
	TransitionScene.change_scene(game, tr("DAY"))
