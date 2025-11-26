extends RigidBody3D


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Player values
@export var walk_speed = 5.0
@export var sprint_speed = 8.0
@export var crouch_speed = 3.0
@export var jump_speed = 4.5
@export var mouse_sensitivity = 0.002

#player states

var captured: bool = true

#Nodes
@onready var camera = $Cam/Camera3D

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())

func _ready() -> void:
	if not is_multiplayer_authority(): return
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.current = true

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	_movement_handler(delta)
	_menu_handler()

#==================================
#    MOVEMENT
#==================================

func _movement_handler(delta) -> void:

	var input = Input.get_vector("left", "right", "forward", "backward")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)

	if Input.is_action_just_pressed("jump"):
		pass

func _input(event):
	if not is_multiplayer_authority(): return
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, -deg_to_rad(70), deg_to_rad(70))

#==================================
#    Menu Handler
#==================================

func _menu_handler() -> void:
	if Input.is_action_just_pressed("menu"):
		toggle_mouse_capture()
		
func toggle_mouse_capture():
	captured = !captured
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if captured else Input.MOUSE_MODE_VISIBLE
