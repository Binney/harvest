extends RigidBody2D

export var size = 50 setget set_size, get_size
export(Colours.SHAPE_COLOURS) var colour = Colours.SHAPE_COLOURS.DEEP_RED setget set_colour, get_colour
export var complete = false setget set_complete, is_complete

export var selected = false
export var popped = false

var h_count = 0
var v_count = 0

signal clicked

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func set_colour(new_colour: int):
	print('Setting colour to ' + str(new_colour))
	colour = new_colour
	$Polygon2D.color = Colours.to_hex(new_colour)

func get_colour():
	return colour

func set_complete(value):
	complete = value
	if complete:
		$Line2D.show()
	else:
		$Line2D.hide()

func is_complete():
	return complete

func highlight_line():
	$Line2D.width = 20

func deselect_line():
	$Line2D.width = 10

var max_speed = 6000

const circle_precision = 24

func get_polygon():
	return $Polygon2D.polygon

func set_size(new_size):
	size = new_size
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

func get_size():
	return size

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	if not selected: return
	var vh = 0
	var vv = 0

	# Go a bit slower on the first frame, so that lets the player nudge
	# just a little amount if they want
	if Input.is_action_just_pressed("ui_left"):
		vh = -0.3
		h_count = 0
	elif Input.is_action_just_pressed("ui_right"):
		vh = 0.3
		h_count = 0
	elif Input.is_action_pressed("ui_left") and linear_velocity.x > -max_speed:
		vh = -0.3 * min(h_count, 5)
		h_count += 1
	elif Input.is_action_pressed("ui_right") and linear_velocity.x < max_speed:
		vh = 0.3 * min(h_count, 5)
		h_count += 1

	if Input.is_action_just_pressed("ui_up"):
		vv = -0.3
		v_count = 0
	elif Input.is_action_just_pressed("ui_down"):
		vv = 0.3
		v_count = 0
	elif Input.is_action_pressed("ui_up") and linear_velocity.y > -max_speed:
		vv = -0.3 * min(v_count, 5)
		v_count += 1
	elif Input.is_action_pressed("ui_down") and linear_velocity.y < max_speed:
		vv = 0.3 * min(v_count, 5)
		v_count += 1

	if vv == 0 and vh == 0:
		return

	apply_central_impulse(Vector2(vh, vv).limit_length(1.5) * delta * 5000)

func pop():
	print('Pop!')
	$Polygon2D.color = Colours.to_hex(Colours.SHAPE_COLOURS.ORANGE)
	$AnimationPlayer.play('Pop', -1, 3)
	popped = true

func disable_line():
	$Line2D.hide()
	$Line2D.width = 0

func _on_RigidBody2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print('You clicked me! ' + get_path())
		emit_signal('clicked')

func _on_RigidBody2D_mouse_entered():
	if is_complete():
		highlight_line()

func _on_RigidBody2D_mouse_exited():
	deselect_line()
