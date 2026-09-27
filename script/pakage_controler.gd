class_name Package
extends Node2D

@onready var pakage: Sprite2D = $Pakage
@onready var price: Label = $Price

var original_package_x: float
var original_price_x: float
@export var price_package: String

enum RarityType {COMUM, RARE, EPIC}

@export var type: RarityType

signal clicked(card_type: RarityType)

func _ready() -> void:
	original_package_x = pakage.position.x
	original_price_x = price.position.x
	price.text = price_package
	price.hide()


func _on_area_2d_mouse_entered() -> void:
	pakage.material.set_shader_parameter("outline_enabled", true)
	price.show()

	var tween = create_tween().set_parallel(true)

	tween.tween_property(
		pakage,
		"position:x",
		original_package_x - 40,
		0.15
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		price,
		"position:x",
		original_price_x - 40,
		0.15
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _on_area_2d_mouse_exited() -> void:
	pakage.material.set_shader_parameter("outline_enabled", false)
	price.hide()

	var tween = create_tween().set_parallel(true)

	tween.tween_property(
		pakage,
		"position:x",
		original_package_x,
		0.15
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		price,
		"position:x",
		original_price_x,
		0.15
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(type)
