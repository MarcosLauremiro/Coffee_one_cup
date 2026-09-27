class_name OpenPackage
extends Node2D

@onready var background: ColorRect = $Background
@onready var package: Node2D = $Package

@onready var animated_comum: AnimatedSprite2D = $Package/AnimatedComum
@onready var animated_rare: AnimatedSprite2D = $Package/AnimatedRare

var type_package_opening: Package.RarityType

func setup(type: Package.RarityType) -> void:
	show()
	if type == Package.RarityType.COMUM:
		package.show()
		animated_comum.frame = 0
	if type == Package.RarityType.RARE:
		package.show()
		animated_rare.frame = 0
