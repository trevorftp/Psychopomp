extends Area3D

@export var character_name: String = "Default Name"
@export var message: String = "Hello, this is a custom message!"
@export var face_sprite: Texture2D

var message_trigger = null
var message_trigger_script = null
var player = null

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered")) # pre-connect signal
	player = get_tree().get_first_node_in_group("player") # find player
	message_trigger_script = load("res://Scripts/MessageTrigger.cs") # load og game script
	
	if message_trigger_script:
		message_trigger = message_trigger_script.new()
		add_child(message_trigger)
		
		message_trigger.name = character_name
		message_trigger.Message = message
		message_trigger.faceSprite = face_sprite
		
		if message_trigger:
			print("[Tsuskido] MessageTrigger successfully initialized with properties.")
		else:
			print("[Tsuskido] MessageTrigger initialization failed.")
	else:
		print("[Tsuskido] Failed to load MessageTrigger script.")
	
func _on_area_entered(area):
	if area.name == "PlayerArea" and area.get_parent() == player and message_trigger:
		message_trigger.OnAreaEntered(player)
	else:
		print("[Tsuskido] Non-player or unexpected node entered:", area)

