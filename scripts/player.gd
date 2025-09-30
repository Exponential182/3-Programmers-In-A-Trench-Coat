extends CharacterBody3D

@onready var camera = $head/Camera3D
@onready var head = $head
@onready var username_display = $head/Username

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var sensitivity = 0.03
var username = "Name"

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	if not is_multiplayer_authority(): return
	$head/Bob.visible = false
	camera.current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	username_display.text = str(username)


func _unhandled_input(event: InputEvent) -> void:
	#Move camera
	if event is InputEventMouseMotion and is_multiplayer_authority():
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40),deg_to_rad(60))


func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
