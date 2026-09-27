extends Node2D

@onready var pakage_controler_comum: Node2D = $PakageControlerComum
@onready var pakage_controler_rare: Node2D = $PakageControlerRare
@onready var pakage_controler_epic: Node2D = $PakageControlerEpic
@onready var open_package: Node2D = $OpenPackage

func _ready():
	pakage_controler_comum.clicked.connect(_on_package_clicked)
	pakage_controler_rare.clicked.connect(_on_package_clicked)
	pakage_controler_epic.clicked.connect(_on_package_clicked)
	
func _on_package_clicked(card_type: Package.RarityType) -> void:
	match card_type:
		pakage_controler_comum.RarityType.COMUM:
			open_package.setup(card_type)

		pakage_controler_rare.RarityType.RARE:
			open_package.setup(card_type)

		pakage_controler_epic.RarityType.EPIC:
			open_package.setup(card_type)

func _on_return_pressed() -> void:
	hide()
