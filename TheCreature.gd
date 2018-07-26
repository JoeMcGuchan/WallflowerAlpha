extends KinematicBody

var direction = Vector3()
var velocity = Vector3()

var gravity = -9.8 * 3
const WALK_SPEED = 20
const ACCL = 7
const DECCL = 15

func _ready():
	pass

func _physics_process(delta):
	#walk will read the players keypresses and change the velocity
	walk(delta)
	
	#add gravity
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	var httCount = get_slide_count()

	if (httCount > 0):
		var collision = get_slide_collision(0)
		if collision.collider is RigidBody:
			collision.collider.apply_impulse(collision.position, -collision.normal)
	
	pass
	
#walk reads the keys and changes the velocity accordingly
func walk(delta):
	direction = Vector3(0,0,0)
	
	#get the direction the player intends to move in
	if Input.is_action_pressed("ui_left"):
		direction.x += 1
	if Input.is_action_pressed("ui_right"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z -= 1
	if Input.is_action_pressed("ui_up"):
		direction.z += 1
	direction = direction.normalized()
	
	#set acceleration
	var acceleration = 0
	var velocity_2D = Vector3(velocity.x,0,velocity.y) 
	if (direction.dot(velocity_2D) > 0):
		acceleration = ACCL
	else:
		acceleration = DECCL
		
	#decide where I would like to go
	var desired_velocity = direction * WALK_SPEED
	
	#change velocity accordingly
	velocity = velocity.linear_interpolate(desired_velocity, acceleration*delta)