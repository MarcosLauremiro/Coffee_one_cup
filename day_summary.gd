class_name DaySummary
extends Node2D

const GAME := "res://scene/game.tscn"

@onready var label: Label = $Label
@onready var button_next_day: Button = $ButtonNextDay
@onready var note: Sprite2D = $Note
@onready var total: Label = $Total

func _ready() -> void:
	var day_done := int(SaveManager.data["day"]) - 1
	label.text = "Dia %d concluído" % day_done
	total.text = "Ganhos: R$ %d" % MoneyManager.get_day_earnings()
	button_next_day.text = tr("Proximo dia")
	button_next_day.visible = false

func _on_finish_text() -> void:
	await get_tree().create_timer(0.5).timeout
	button_next_day.visible = true

func _on_button_next_day_pressed() -> void:
	get_tree().change_scene_to_file(GAME)
