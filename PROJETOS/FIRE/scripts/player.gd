extends KinematicBody2D

onready var rayE = get_node("rayE")
onready var rayD = get_node("rayD")
onready var sprite = get_node("Anim")
onready var sprite2 = get_node("Anim2")
onready var timer = get_node("Timer")


#-------------------------------------------------------------------------------
# This demo shows how to build a kinematic controller.

# Member variables
const GRAVITY = 1100.0 # pixels/second/second


const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 600
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 200
const STOP_FORCE = 1300
const JUMP_SPEED = 700
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var on_air_time = 100
var jumping = false


var prev_jump_pressed = false


func _physics_process(delta):

	var force = Vector2(0, GRAVITY)
	
	var walk_left = Input.is_action_pressed("move_left")
	var walk_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	var attack = Input.is_action_pressed("attack")
	
	var stop = true
	
	if walk_left:
		timer.start()
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			force.x -= WALK_FORCE
			stop = false
	elif walk_right:
		timer.start()
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			stop = false

	if stop:
		
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign
	

	velocity += force * delta	

	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor():
		on_air_time = 0
		
	if jumping and velocity.y > 0:
		jumping = false
		
	
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:

		velocity.y = -JUMP_SPEED
		jumping = true
	
	on_air_time += delta
	prev_jump_pressed = jump
	
	var no_chao = rayE.is_colliding() or rayD.is_colliding()
	
	
	
	if walk_right:
		sprite2.position.x = 177.41069
		sprite2.set_flip_h(false)
		sprite.set_flip_h(false)
	if walk_left:
		sprite2.position.x = -177.15995
		
		sprite2.set_flip_h(true)
		sprite.set_flip_h(true)
		
	if (walk_left or walk_right) and no_chao:
		sprite2.hide()
		sprite.show()
		sprite.animation = "andar"
		sprite.play()
		
		
	elif (walk_left or walk_right) and !no_chao:
		sprite2.hide()
		sprite.show()
		sprite.animation = "pular"
		sprite.play()
		
	elif !no_chao:
		sprite2.hide()
		sprite.show()
		sprite.animation = "pular"
		sprite.play()
	
	elif attack:
		sprite.hide()
		sprite2.show()
		sprite2.animation = "attack"
		sprite2.play()
		
		
	else:
		sprite2.hide()
		sprite.show()
		sprite.stop()
		sprite.animation = "andar"
		sprite.set_frame(1)
		
		
		
		


func _on_Timer_timeout():
	print(WALK_FORCE)
	WALK_FORCE = 20000
	timer.stop()
