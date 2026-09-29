extends Node

const PATH := "user://tutorials.cfg"
var _cfg := ConfigFile.new()

func _ready() -> void:
	_cfg.load(PATH)

func has_seen(id: String) -> bool:
	return SaveManager.is_tutorial_done(id)

func mark_seen(id: String) -> void:
	SaveManager.mark_tutorial_done(id)

func reset_all() -> void:
	_cfg.clear()
	_cfg.save(PATH)
