extends TextureButton
var CustomSceneLoader = preload("res://Scripts/CustomSceneLoader.gd")

@export var destination: String
var loadScene: PackedScene
@export var sceneLoader: String = "res://modScenes/ModSceneLoader.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	loadScene = ResourceLoader.load(sceneLoader)
	pass # Replace with function body.


func _pressed():
	CustomSceneLoader.DestinationScene = "res://modScenes/" + destination + ".tscn"
	get_tree().change_scene_to_packed(loadScene)
	pass
