extends CharacterBody2D


const SPEED = 300.0
var currentSpeed = 300
const minSpeed = 30
const JUMP_VELOCITY = -400.0
const max_jumps : int = 2
var jumps_left : int = 2
var inSlide : bool = false
const slideDecel : float = 0.50
const butteredslideDecel : float = 0.99

func _ready() -> void:
	Gm.player = self

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jumps_left = max_jumps

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or jumps_left > 0):
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * currentSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, currentSpeed)
	
	if Input.is_action_just_pressed("slide") && inSlide == false:
		inSlide = true
		scale.y = 0.7

	
	if inSlide == true:
		#play slide animation hier please
		if currentSpeed > minSpeed:
			if Gm.butterAmount > 0:
				currentSpeed *= butteredslideDecel
				Gm.butterAmount -= delta * 20
			else:
				currentSpeed *= slideDecel
			
		
		if Input.is_action_just_released("slide"):
			scale.y = 1

			inSlide = false
			currentSpeed = SPEED
	print(inSlide , currentSpeed)
	move_and_slide()
