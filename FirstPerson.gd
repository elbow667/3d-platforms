extends KinematicBody

var damage = 10
const MAX_CAM_SHAKE = 0.3


var speed = 10
var acceleration = 6
var air_acceleration = 1
var normal_accelleration = 6
var gravity = 20
var jump = 11

var mouse_sensitivity = 0.05

var direction = Vector3()
var velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()
var fall = Vector3()
var full_contact = false
var bouncing = false

onready var head = $Head
onready var ground_check = $GroundCheck
onready var anim_player = $AnimationPlayer
onready var camera = $Head/Camera
onready var raycast = $Head/Camera/RayCast



# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):  # only move if mouse is captured
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED: 
		if event is InputEventMouseMotion:
			rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
			head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
			head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
	## if user clicks into the window to resume playing
	if event.is_action_pressed("click"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_tree().set_input_as_handled()	# don't fire weapon

func fire():
	if Input.is_action_pressed("fire"):
		if not anim_player.is_playing():
			
			camera.translation = lerp(camera.translation, 
			Vector3(rand_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), 
			rand_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), 0), 0.5)
			
			if raycast.is_colliding():
				var target = raycast.get_collider()
				if target.is_in_group("Enemy"):
					print("hit enemy")
					target.hit = true
				#	target.health. -= damage
					
					
		anim_player.play("AssaultFire")
	else:
		camera.translation = Vector3()

func _process(delta):
	
	fire()
	direction = Vector3()
	
	if ground_check.is_colliding():
		full_contact = true
	else:
		full_contact = false
	
	if not is_on_floor():
#		fall.y -= gravity * delta
		gravity_vec += Vector3.DOWN * gravity * delta
		acceleration = air_acceleration
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
		acceleration = normal_accelleration
	else:
		gravity_vec = -get_floor_normal()
		acceleration = normal_accelleration
		
	if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()) or bouncing:
#		fall.y = jump
		gravity_vec = Vector3.UP * jump
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
		
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
		
	direction = direction.normalized()
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	movement.z = velocity.z + gravity_vec.z
	movement.x = velocity.x + gravity_vec.x
	movement.y = gravity_vec.y
	#velocity = move_and_slide(velocity, Vector3.UP)
	#move_and_slide(fall, Vector3.UP)
	move_and_slide(movement, Vector3.UP)


func bounce():
	print("bounce")
	bouncing = true
	yield(get_tree().create_timer(1), "timeout")
	bouncing = false
	#gravity_vec = Vector3.UP * jump * 5
