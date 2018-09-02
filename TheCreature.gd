extends KinematicBody

var direction = Vector3()
var velocity = Vector3()

var gravity = -9.8 * 3
const WALK_SPEED = 20
const ACCL = 15
const DECCL = 50
const AIR_RESISTANCE = 0.9

#used to determine if the creature is just above ground
var tail_touching = false

func _ready():
	pass

func _physics_process(delta):
		
	if is_on_floor():
		tail_touching = true
	else:
		if !$Tail.is_colliding():
			tail_touching = false
		
	if (tail_touching and !is_on_floor()):
		move_and_collide(Vector3(0,-1,0))
		
	#walk will read the players keypresses and change the velocity
	if tail_touching: walk(delta)
	
	#apply other forces
	forces(delta)
	
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
	
	#change velocity accordingly (but ensure we don't effect y value)
	velocity.x = velocity.linear_interpolate(desired_velocity, acceleration*delta).x
	velocity.z = velocity.linear_interpolate(desired_velocity, acceleration*delta).z
	
#this function does air resistance and gravity
func forces(delta):
	#add gravity	
	velocity.y += gravity * delta
	
	#add air resistance
	
	#air resistance doesn't apply on ground
	#air resistance doesn't effect gravity as much
	if !tail_touching:
		velocity.x = velocity.x*AIR_RESISTANCE
		velocity.z = velocity.z*AIR_RESISTANCE