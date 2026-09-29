class_name TutorialOverlay
extends Control

signal finished

@onready var highlight: Panel = %Highlight
@onready var box: PanelContainer = %Box
@onready var title_label: Label = %Title
@onready var body: RichTextLabel = %Body
@onready var page_label: Label = %Page
@onready var skip_button: Button = %Skip
@onready var next_button: Button = %Next
@onready var dim: ColorRect = %ColorRecDim

var _steps: Array = []
var _index := 0


# Cada passo é um Dictionary:
# { "title": "TUT_TITLE", "text": "TUT_TEXT", "target": Control (opcional) }
static func open(parent: Node, steps: Array) -> TutorialOverlay:
	var overlay: TutorialOverlay = load("res://scene/tutorial_overlay.tscn").instantiate()
	overlay._steps = steps
	parent.add_child(overlay)
	return overlay


func _ready() -> void:
	highlight.mouse_filter = Control.MOUSE_FILTER_IGNORE
	skip_button.hide()
	next_button.pressed.connect(_next)
	_show_step()

func _show_step() -> void:
	var step: Dictionary = _steps[_index]

	title_label.text = tr(step.get("title", ""))
	body.text = tr(step.get("text", ""))
	page_label.text = "%d/%d" % [_index + 1, _steps.size()]

	var waiting: bool = step.get("wait") is Signal
	var is_last := _index == _steps.size() - 1

	var filter := Control.MOUSE_FILTER_IGNORE if waiting else Control.MOUSE_FILTER_STOP
	mouse_filter = filter
	box.mouse_filter = filter
	body.mouse_filter = filter
	dim.visible = not waiting
	next_button.visible = not waiting
	next_button.text = tr("TUT_DONE") if is_last else tr("TUT_NEXT")

	_update_highlight(step.get("target"))

	if waiting:
		_wait_for(step["wait"], _index)


func _wait_for(sig: Signal, step_index: int) -> void:
	await sig
	if not is_instance_valid(self) or step_index != _index:
		return
	_next()


func _update_highlight(target: Variant) -> void:
	if target == null or not is_instance_valid(target):
		highlight.hide()
		return

	var current := _index
	await get_tree().process_frame
	if current != _index:
		return

	var rect: Rect2 = _get_target_rect(target).grow(6)
	highlight.global_position = rect.position
	highlight.size = rect.size
	highlight.show()


func _get_target_rect(target: Node) -> Rect2:
	if target is Control:
		return target.get_global_rect()
	if target is Sprite2D:
		return target.get_global_transform_with_canvas() * target.get_rect()
	if target is Node2D:
		var pos: Vector2 = target.get_global_transform_with_canvas().origin
		return Rect2(pos - Vector2(40, 40), Vector2(80, 80))
	return Rect2()

func _next() -> void:
	_index += 1
	if _index >= _steps.size():
		_close()
	else:
		_show_step()


func _close() -> void:
	finished.emit()
	queue_free()
