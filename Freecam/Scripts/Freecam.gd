extends Camera3D

var freecam_active = false
var speed = 12.0
var rotation_speed = 0.1
var player_object = null
var player_camera = null
var toggle_key = KEY_F
var max_vertical_angle = 80
var ui_canvas = null

var toggle_cooldown = 0.3
var toggle_timer = 0.0

var current_pitch = 0.0
var current_yaw = 0.0

func _ready():
    player_object = get_tree().get_first_node_in_group("player")
    if player_object:
        print("[Tsuskido] PlayerObject found:", player_object.name)
        
        # Attempt to find the player’s camera with the specified path
        player_camera = player_object.get_node("Head/SpringArm3D Z/MainCamera")
        if player_camera:
            print("[Tsuskido] Player camera found:", player_camera.name)
            player_camera.current = true  # Ensure player camera is active by default
        else:
            print("[Tsuskido] No camera found at PlayerObject/Head/SpringArm3D Z/MainCamera.")

        # Locate the UI canvas layer and store reference
        ui_canvas = player_object.get_node("UI Overlay/CanvasLayer")
        if ui_canvas:
            print("[Tsuskido] UI Canvas found:", ui_canvas.name)
        else:
            print("[Tsuskido] UI Canvas not found at PlayerObject/UI Overlay/CanvasLayer.")
    else:
        print("[Tsuskido] PlayerObject not found in the 'player' group.")

func _process(delta):
    toggle_timer -= delta
    if Input.is_key_pressed(toggle_key) and toggle_timer <= 0.0:
        if !freecam_active:
            enable_freecam()
        else:
            disable_freecam()
        toggle_timer = toggle_cooldown

    if freecam_active:
        freecam_movement(delta)
        handle_rotation(delta)

func freecam_movement(delta):
    var direction = Vector3.ZERO
    
    if Input.is_key_pressed(KEY_W):
        direction.z -= 1
    if Input.is_key_pressed(KEY_S):
        direction.z += 1
    if Input.is_key_pressed(KEY_A):
        direction.x -= 1
    if Input.is_key_pressed(KEY_D):
        direction.x += 1

    if Input.is_key_pressed(KEY_SHIFT):
        direction.y += 1
    if Input.is_key_pressed(KEY_CTRL):
        direction.y -= 1
    
    if direction != Vector3.ZERO:
        direction = direction.normalized()
    translate(direction * speed * delta)

func handle_rotation(delta):
    if freecam_active and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

    var mouse_motion = Input.get_last_mouse_velocity()
    
    current_yaw -= mouse_motion.x * rotation_speed * delta
    current_pitch = clamp(current_pitch - mouse_motion.y * rotation_speed * delta, -max_vertical_angle, max_vertical_angle)
    
    rotation_degrees = Vector3(current_pitch, current_yaw, 0)

func enable_freecam():
    if player_camera:
        player_camera.current = false
    self.current = true
    if player_object:
        player_object.set_process(false)
        print("[Tsuskido] Freecam enabled. Player control disabled.")
    else:
        print("[Tsuskido] Unable to disable player control - PlayerObject not found.")
    
    if ui_canvas:
        ui_canvas.visible = false
        print("[Tsuskido] UI Canvas hidden.")
    
    freecam_active = true

func disable_freecam():
    if player_camera:
        player_camera.current = true
    self.current = false
    if player_object:
        player_object.set_process(true)
        print("[Tsuskido] Freecam disabled. Player control enabled.")
    
    if ui_canvas:
        ui_canvas.visible = true
        print("[Tsuskido] UI Canvas shown.")
    
    freecam_active = false
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
