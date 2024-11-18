extends Node
class_name CustomSceneLoader

static var DestinationScene : String
var loadStatus = 0
var progress = []
var loadReady = false
var newScene
@export var LoadText : RichTextLabel


func _ready():
	loadReady = false
	ResourceLoader.load_threaded_request(DestinationScene)


func _process(_delta):
	if (!loadReady):
		loadStatus = ResourceLoader.load_threaded_get_status(DestinationScene,progress)
		if (loadStatus == ResourceLoader.THREAD_LOAD_LOADED):
			newScene = ResourceLoader.load_threaded_get(DestinationScene) as PackedScene
			if LoadText != null:
				LoadText.text = "[wave]Press any key to continue"
			loadReady = true
	
func _input(event):
	if event.is_pressed() && loadReady:
		sceneLoad()

func sceneLoad():
	if (loadReady):
		get_tree().change_scene_to_packed(newScene)
