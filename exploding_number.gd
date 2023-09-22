extends Label

@export var number = 3

var gravity = 144.0 * 8
var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(number)
	pop_it()


func _physics_process(delta):
	var movement = Vector2()
	velocity.y = min(0, velocity.y + gravity * delta)
	movement.x = velocity.x
	movement.y += velocity.y
	movement.y += gravity

	position += movement * delta


func pop_it():
	velocity.x = randf() * 288.0 - 144.0
	velocity.y = gravity * -(randf() * 0.75 + 1.0)
