class_name Card
extends Node2D

signal clicked(card: Card)
signal stacked(card: Card)
signal dropped(card: Card)

const DEFAULT_BACK: Texture2D = preload("res://assets/cards/ingredient_card_back.png")

@onready var front: Sprite2D = $Front/Front
@onready var back: Sprite2D = $Back/Back
@onready var magnet: Area2D = $Magnet

const DRAG_THRESHOLD := 5.0

var data: CardData

var recipe: RecipeData = null

var is_front := false
var is_flipping := false
var is_removing := false
var has_moved := false

# Quem cria a carta liga isso (a mesa liga, o pacote não)
var draggable := false

var is_pressed := false
var is_dragging := false
var drag_offset := Vector2.ZERO
var mouse_down_position := Vector2.ZERO

func _ready() -> void:
	magnet.input_pickable = false
	_apply_back()


func setup(card_data: CardData) -> void:
	data = card_data
	render()


func render() -> void:
	if data == null:
		return
	front.texture = data.front
	back.texture = data.back if data.back != null else DEFAULT_BACK
	_apply_back()


func show_front() -> void:
	if is_flipping or is_removing:
		return
	_apply_front()


func show_back() -> void:
	if is_flipping or is_removing:
		return
	_apply_back()


func _apply_front() -> void:
	is_front = true
	front.visible = true
	back.visible = false


func _apply_back() -> void:
	is_front = false
	front.visible = false
	back.visible = true


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
	if is_front:
		_apply_back()
	else:
		_apply_front()


func remove_card() -> void:
	if is_flipping or is_removing:
		return
	is_removing = true

	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.2)
	await tween.finished


# --- INPUT ---

func _on_area_2d_input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
) -> void:
	if is_flipping or is_removing:
		return
	if not (event is InputEventMouseButton):
		return
	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return

	# Sempre registra o clique (serve pro pacote e pra mesa)
	is_pressed = true
	has_moved = false
	mouse_down_position = get_global_mouse_position()
	drag_offset = global_position - mouse_down_position


func _input(event: InputEvent) -> void:
	if not is_pressed:
		return

	if event is InputEventMouseMotion:
		var mouse := get_global_mouse_position()

		# Passou do limiar? Então já não é mais um clique, mesmo que a carta não arraste
		if mouse_down_position.distance_to(mouse) >= DRAG_THRESHOLD:
			has_moved = true

		if not can_drag():
			return

		if not is_dragging:
			if not has_moved:
				return
			is_dragging = true
			move_to_front()
		global_position = mouse + drag_offset
		return

	# Soltou o botão
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and not event.pressed:
		is_pressed = false

		if is_dragging:
			is_dragging = false
			dropped.emit(self)
			if is_removing:
				return

			var target := get_magnet_target()
			if target != null:
				global_position = target.global_position + Vector2(0, -20)
				stacked.emit(self)
		elif not has_moved:
			# Só um clique de verdade: avisa o dono (virar, coletar...)
			clicked.emit(self)


func can_drag() -> bool:
	return draggable


func get_magnet_target() -> Card:
	var top_card: Card = null

	for area in magnet.get_overlapping_areas():
		var card := area.get_parent() as Card

		if card == null or card == self:
			continue
		if card.is_removing:
			continue

		if top_card == null or _is_above(card, top_card):
			top_card = card

	return top_card


# true se "a" está visualmente acima de "b"
func _is_above(a: Card, b: Card) -> bool:
	if a.z_index != b.z_index:
		return a.z_index > b.z_index
	return a.get_index() > b.get_index()

func start_drag() -> void:
	is_pressed = true
	is_dragging = true
	has_moved = true
	mouse_down_position = get_global_mouse_position()
	drag_offset = global_position - mouse_down_position
	move_to_front()
