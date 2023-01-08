extends Node2D

var shape_scene = preload('IntersectionShape.tscn')
var circle_scene = preload('Circle.tscn')
var intersection_pieces = {}

func _ready():
	#$LevelCompleteUI.hide()
	for i in 5:
		spawn_circle()
	var circles = get_tree().get_nodes_in_group('circles')
	for circle in circles:
		for shape in get_tree().get_nodes_in_group('shapes'):
			add_intersection(circle, shape)

func spawn_circle():
	var circle = circle_scene.instance()
	circle.position = Vector2(randi() % 1024, randi() % 1000 + 3800)
	#circle.linear_velocity = Vector2(randi() % 20 - 10, randi() % 20 - 10)
	# TODO better initial random impulse/velocity
	circle.apply_central_impulse(Vector2(randi() % 20 - 10, randi() % 20 - 10))
	circle.colour = Colours.get_rand_colour()
	circle.gravity_scale = 1
	circle.disable_line()
	circle.add_to_group('circles')
	$Circles.add_child(circle)

func add_intersection(shape1, shape2):
	var intersections_with_1 = intersection_pieces[shape1.get_path()] if intersection_pieces.has(shape1.get_path()) else {}

	var intersection_shape = shape_scene.instance()
	var colour = Colours.mix_colours(shape1.get_colour(), shape2.get_colour())
	#print('Mixed and setting to ' + str(colour))
	intersection_shape.set_colour(colour)
	# Empty polygon until first physics_process
	$IntersectionPieces.add_child(intersection_shape)

	intersections_with_1[shape2.get_path()] = intersection_shape
	intersection_pieces[shape1.get_path()] = intersections_with_1

func _process(delta):
	if Input.is_action_just_pressed("ui_focus_prev"):
		# Shift+tab
		#select_previous_circle()
		pass
	elif Input.is_action_just_pressed("ui_focus_next"):
		# Tab
		#select_next_circle()
		pass
	elif Input.is_action_just_pressed("ui_accept"):
		click_current_circle()
		pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	scale_circle($Circle)
	$Area2D/BigHoleThing.rotation += 0.01
	for circle in get_tree().get_nodes_in_group('circles'):
		for shape in get_tree().get_nodes_in_group('shapes'):
			mark_intersections(circle, shape)
		circle.set_complete(calculate_complete(circle))

func scale_circle(circle: RigidBody2D):
	# 60 at top, 20 at bottom
	# 0 at top, 4800 at bottom
	var desired_size = int(round((4800 - circle.position.y) / 120)) + 20
	if circle.size != desired_size:
		# the rescaling is a bit of a faff so only do it if needed
		circle.size = desired_size

func mark_intersections(circle: Node2D, shape2: Node2D):
	var intersection_marker = intersection_pieces[circle.get_path()][shape2.get_path()]
	var intersections = Geometry.intersect_polygons_2d(
		get_polygon_global_coords(circle), get_polygon_global_coords(shape2))
	if intersections.size() > 0:
		intersection_marker.set_polygon(intersections[0])
	else:
		intersection_marker.set_polygon(PoolVector2Array())

	pass

func get_polygon_global_coords(shape: Node2D):
	if not shape.has_method('get_polygon'): return
	var result = PoolVector2Array()
	var transform = shape.get_global_transform()
	for point in shape.get_polygon():
		result.append(transform.xform(point))
	return result

func _on_NextLevelButton_pressed():
	# TODO fade
	get_tree().change_scene("res://Level6.tscn")

func calculate_complete(circle: Node2D):
	var pieces = intersection_pieces[circle.get_path()]
	for shape in pieces.keys():
		if pieces[shape].get_colour() != Colours.SHAPE_COLOURS.ANSWER_RED && pieces[shape].get_colour() != Colours.SHAPE_COLOURS.FINAL_WHITE:
			continue

		# Check intersection
		var first = get_polygon_global_coords(circle)
		var second = get_polygon_global_coords(get_node(shape))
		var difference = Geometry.clip_polygons_2d(first, second)
		if difference.empty():
			return true
	return false

func complete_level():
	print('Completed level!')
	$ZeroGArea.gravity = -50
	$IntersectionPieces.hide()
	$Circle.mode = RigidBody2D.MODE_STATIC
	$Circle.rotation = 0
	$Circle/Camera2D/Label.show()
	$Circle/Camera2D/Button.show()
	$AnimationPlayer.play("Finish")
	$AnimationPlayer.queue("Show button")
	
	# TODO
	#$LevelCompleteUI.show()
	#$LevelCompleteUI/NextLevelButton.grab_focus()

func select_next_circle():
	var circles = get_tree().get_nodes_in_group('circles')
	for i in range(circles.size()):
		if circles[i].selected:
			circles[i].selected = false
			circles[(i + 1) % circles.size()].selected = true
			return

func select_previous_circle():
	var circles = get_tree().get_nodes_in_group('circles')
	for i in range(circles.size()):
		if circles[i].selected:
			circles[i].selected = false
			circles[i - 1].selected = true
			return

func click_current_circle():
	for circle in get_tree().get_nodes_in_group('circles'):
		if circle.selected:
			click_circle(circle)
			return

func deselect_all_circles():
	for circle in get_tree().get_nodes_in_group('circles'):
		circle.selected = false

func all_circles_popped():
	for circle in get_tree().get_nodes_in_group('circles'):
		if not circle.popped:
			return false
	return true

func click_circle(circle):
	print('Selected ' + circle.get_path())
	deselect_all_circles()
	circle.selected = true
	if circle.is_complete() and not circle.popped:
		circle.pop()
		for piece in intersection_pieces[circle.get_path()].values():
			piece.hide()
		complete_level()

func _on_Circle_clicked():
	click_circle($Circle)
	pass # Replace with function body.


func _on_Button_pressed():
	get_tree().change_scene("res://Splash.tscn")
