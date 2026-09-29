class_name Order
extends Control

const ORDER_TIME := 40.0

const COLOR_GREEN := Color("46bc77ff")
const COLOR_RED := Color("cf462eff")

var recipe: RecipeData
var customer: Customer

var normal_style := StyleBoxFlat.new()
var danger_style := StyleBoxFlat.new()

@onready var recipe_name: Label = $PanelContainer/MarginContainer/VBoxContainer/Label
@onready var price: Label = $PanelContainer/MarginContainer/VBoxContainer/Price

@onready var timer: Timer = $Timer
@onready var progress_bar: ProgressBar = $ProgressBar

var finished := false

signal timer_out

func _ready() -> void:
	normal_style.bg_color = COLOR_GREEN
	danger_style.bg_color = COLOR_RED

	progress_bar.add_theme_stylebox_override("fill", normal_style)


func setup(order_data: RecipeData) -> void:
	recipe = order_data
	recipe_name.text = "Um " + order_data.name
	price.text = "$%d" % order_data.price

	timer.wait_time = ORDER_TIME
	timer.start()

	progress_bar.max_value = ORDER_TIME
	progress_bar.value = ORDER_TIME


func _process(_delta: float) -> void:
	if finished:
		return
	
	progress_bar.value = timer.time_left

	if timer.time_left <= 10.0:
		progress_bar.add_theme_stylebox_override("fill", danger_style)
	else:
		progress_bar.add_theme_stylebox_override("fill", normal_style)

func _on_timer_timeout() -> void:
	finished = true
	progress_bar.value = 0
	timer_out.emit()
	
	
