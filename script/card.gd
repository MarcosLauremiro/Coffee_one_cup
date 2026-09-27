class_name Card
extends Node2D

signal clicked(card: Card)

@onready var front: Sprite2D = $Front/Front
@onready var back: Sprite2D = $Back/Back

var data: CardData
var is_front := false
var is_flipping := false
var is_removing := false


func _ready() -> void:
	back.visible = true
	front.visible = false


func setup(card_data: CardData) -> void:
	data = card_data
	render()


func render() -> void:
	if data == null:
		return

	front.texture = data.front
	back.texture = data.back

	back.visible = true
	front.visible = false

	is_front = false


func flip() -> void:
	if is_flipping or is_removing:
		return

	is_flipping = true

	var tween := create_tween()

	tween.tween_property(self, "scale:x", 0.0, 0.15)

	tween.tween_callback(_change_side)

	tween.tween_property(self, "scale:x", 1.0, 0.15)

	await tween.finished

	is_flipping = false


func _change_side() -> void:
	is_front = !is_front

	front.visible = is_front
	back.visible = !is_front


func remove_card() -> void:
	if is_flipping or is_removing:
		return

	is_removing = true

	var tween := create_tween()

	tween.tween_property(
		self,
		"scale",
		Vector2(1.1, 1.1),
		0.1
	)

	tween.parallel().tween_property(
		self,
		"modulate:a",
		0.0,
		0.2
	)

	await tween.finished

	clicked.emit(self)


func _on_area_2d_input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
) -> void:

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if is_flipping or is_removing:
				return

			clicked.emit(self)
