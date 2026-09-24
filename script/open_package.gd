class_name OpenPackage
extends Node2D

@onready var background: ColorRect = $Background
@onready var package_comum: Node2D = $PackageComum

func setup(type: Package.RarityType) -> void:
	show()
	if type == Package.RarityType.COMUM:
		package_comum.show()
		var anim = package_comum.get_child(0)
		anim.frame = 0
