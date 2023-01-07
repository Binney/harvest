extends RigidBody2D

export var size = 50

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var max_speed = 100

const circle_precision = 24

func get_polygon():
	return $Polygon2D.polygon

# Called when the node enters the scene tree for the first time.
func _ready():
	var shape = CircleShape2D.new()
	shape.radius = size
	$CollisionShape2D.shape = shape

	var polygon = PoolVector2Array()
	for i in range(circle_precision):
		polygon.append(Vector2(size, 0).rotated(i * 2 * PI / circle_precision))
	$Polygon2D.polygon = polygon
	pass # Replace with function body.

func _physics_process(delta):
	var vh = 0
	var vv = 0

	if Input.is_action_pressed("ui_left") and linear_velocity.x > -max_speed:
		vh = -1
	elif Input.is_action_pressed("ui_right") and linear_velocity.x < max_speed:
		vh = 1

	if Input.is_action_pressed("ui_up") and linear_velocity.y > -max_speed:
		vv = -1
	elif Input.is_action_pressed("ui_down") and linear_velocity.y < max_speed:
		vv = 1

	if vv == 0 and vh == 0:
		linear_damp = 2
		return

	# this is wrong, it makes the whole thing wobble because it oscillates between maxspeed and a bit below
	# TODO fix
	linear_damp = -1
	apply_central_impulse(Vector2(vh, vv) * 100)
