extends CanvasLayer

@onready var money: Label = $Money/Money
@onready var timer_cont: Label = $Timer/TimerCont
@onready var day: Label = $Days/Day

var game_timer: Timer
var time_left: int = 30

signal end_timer

func _ready() -> void:
	MoneyManager.money = int(SaveManager.data.get("money", 0))
	MoneyManager.money_changed.connect(_on_money_changed)

	money.text = str(MoneyManager.money)
	day.text = str(int(SaveManager.data.get("day", 1)))

	money.text = str(MoneyManager.money)
	day.text = str(int(SaveManager.data.get("day", 1)))

	game_timer = Timer.new()
	game_timer.wait_time = 1.0
	game_timer.one_shot = false

	add_child(game_timer)

	game_timer.timeout.connect(_on_game_timer_timeout)

	timer_cont.text = str(time_left)

	start_timer()

func _on_money_changed(value: int) -> void:
	money.text = str(value)

func start_timer() -> void:
	time_left = 300
	timer_cont.text = str(time_left)

	game_timer.start()

func _on_game_timer_timeout() -> void:
	time_left -= 1

	timer_cont.text = str(time_left)

	if time_left <= 0:
		game_timer.stop()
		_on_timer_finished()

func _on_timer_finished() -> void:
	end_timer.emit()
