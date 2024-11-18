extends TextureButton

@export var destination: String
var loadScene: PackedScene
@export var modSceneLoader: String = "res://modScenes/ModSceneLoader.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	loadScene = load(modSceneLoader)
	pass # Replace with function body.


func _pressed():
	ModSceneLoader.DestinationScene = "res://modScenes/" + destination + ".tscn"
	get_tree().change_scene_to_packed(loadScene)
	pass
