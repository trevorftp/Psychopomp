extends Node2D

@export var checker: bool
var freecam_script = preload("res://Scripts/Freecam.gd")

func _ready():
    if !checker:
        PlayerPrefs.set_pref("TPSUnlocked", true)
    elif PlayerPrefs.get_pref("TPSUnlocked", false) == false:
        hide()
    else:
        attach_freecam()

func attach_freecam():
    var player = get_tree().get_first_node_in_group("player")
    if player:
        if not player.has_node("Freecam"):
            var freecam_instance = freecam_script.new()
            player.call_deferred("add_child", freecam_instance)
            freecam_instance.name = "Freecam"
            print("Freecam instance successfully attached to PlayerObject.")
    else:
        print("Failed to find PlayerObject in the 'player' group.")
