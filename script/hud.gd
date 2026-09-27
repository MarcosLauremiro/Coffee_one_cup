extends CanvasLayer

@onready var money: Label = $Money/Money

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	money.text = str(MoneyManager.money)
