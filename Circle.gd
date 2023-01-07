extends RigidBody2D

export var size = 50
export var colour = Color8(128, 35, 37) setget set_colour, get_colour
export var complete = false setget set_complete, is_complete

export var selected = false
export var popped = false

signal clicked

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_colour(new_colour: Color):
	colour = new_colour
	$Polygon2D.color = colour

func get_colour():
	return colour

func set_complete(value):
	complete = value
	if complete:
		#print('Complete!')
		$Line2D.show()
	else:
		$Line2D.hide()

func is_complete():
	return complete

func highlight_line():
	$Line2D.width = 20

func deselect_line():
	$Line2D.width = 10

var max_speed = 150

const circle_precision = 24

func get_polygon():
	return $Polygon2D.polygon

# Called when the node enters the scene tree for the first time.
func _ready():
	var shape = CircleShape2D.new()
	shape.radius = size
	$CollisionShape2D.shape = shape

	var polygon = PoolVector2Array()
	$Line2D.clear_points()
	for i in range(circle_precision):
		var point = Vector2(size, 0).rotated(i * 2 * PI / circle_precision)
		polygon.append(point)
		$Line2D.add_point(point)
	$Line2D.add_point($Line2D.get_point_position(0)) # complete the circle
	$Line2D.add_point($Line2D.get_point_position(1)) # complete the circle
	$Polygon2D.polygon = polygon
	pass # Replace with function body.

func _physics_process(delta):
	if not selected: return
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

func pop():
	print('Pop!')
	$Polygon2D.color = Colours.BLUE
	$AnimationPlayer.play('Pop', -1, 3)
	popped = true


func _on_RigidBody2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print('You clicked me! ' + get_path())
		emit_signal('clicked')

