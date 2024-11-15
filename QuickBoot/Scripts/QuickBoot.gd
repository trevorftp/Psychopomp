extends Node

@export var Destination : String = "res://Scenes/modMenu.tscn"  # Default destination scene
@export var transition : bool = false
@export var transitionTime : float = 5

# Constants
const FASTBOOT_FILE_PATH = "user://fastboot.ini"
const MIN_WAIT_TIME = 1.25

func _ready():
	# Load destination from fastboot.ini if it exists, or create it with the default
	load_destination_from_fastboot()
	print("Destination scene:", Destination)
	
	# Begin the scene transition after the delay
	_changeScene()

func load_destination_from_fastboot():
	# Check if the fastboot.ini file exists
	if FileAccess.file_exists(FASTBOOT_FILE_PATH):
		var file = FileAccess.open(FASTBOOT_FILE_PATH, FileAccess.READ)
		if file:
			var scene_path = file.get_line().strip_edges()
			# Check if the specified scene path exists, else use the default
			if scene_exists(scene_path):
				Destination = scene_path
			else:
				print("Scene not found, loading default: ", Destination)
			file.close()
	else:
		# If the file doesn't exist, create it with the default scene path
		var file = FileAccess.open(FASTBOOT_FILE_PATH, FileAccess.WRITE)
		file.store_line(Destination)
		file.close()

# Function to check if a scene file exists at the given path
func scene_exists(scene_path: String) -> bool:
	return ResourceLoader.exists(scene_path)

# Function to delay the scene change by MIN_WAIT_TIME
func _changeScene():
	await wait(MIN_WAIT_TIME)  # Wait for the minimum time before changing scenes
	print("Changing scene to:", Destination)

	# Load the destination scene with or without transition
	var scene = load(Destination) as PackedScene
	if scene:
		if transition:
			Fade.crossfade_prepare(transitionTime, "WeirdWipe", false, false)
			get_tree().change_scene_to_packed(scene)
			Fade.crossfade_execute()
		else:
			get_tree().change_scene_to_packed(scene)
	else:
		print("Failed to load scene, reverting to default")
		get_tree().change_scene("res://Scenes/modMenu.tscn")  # Load default if loading fails

# Helper function for waiting with delay
func wait(seconds):
	var timer = Timer.new()
	timer.wait_time = seconds
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
