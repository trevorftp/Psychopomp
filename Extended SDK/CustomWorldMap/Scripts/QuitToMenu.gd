extends Button
var CustomSceneLoader = preload("res://Scripts/CustomSceneLoader.gd")

# the original quit script was being really weird when exiting so oh well.
var loadScene: PackedScene
@export var sceneLoader: String = "res://modScenes/ModSceneLoader.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	loadScene = ResourceLoader.load(sceneLoader)

func _pressed():
	CustomSceneLoader.DestinationScene = "res://Scenes/title_screen.tscn"
	get_tree().change_scene_to_packed(loadScene)
