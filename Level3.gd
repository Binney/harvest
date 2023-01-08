extends Node2D

var shape_scene = preload('IntersectionShape.tscn')
var intersection_pieces = {}

func _ready():
	$LevelCompleteUI.hide()
	for circle in get_tree().get_nodes_in_group('circles'):
		for shape in get_tree().get_nodes_in_group('shapes'):
			add_intersection(circle, shape)

func add_intersection(shape1, shape2):
	var intersections_with_1 = intersection_pieces[shape1.get_path()] if intersection_pieces.has(shape1.get_path()) else {}

	var intersection_shape = shape_scene.instance()
	var colour = Colours.mix_colours(shape1.get_colour(), shape2.get_colour())
	print('Mixed and setting to ' + colour)
	intersection_shape.set_colour(colour)
	# Empty polygon until first physics_process
	add_child(intersection_shape)

	intersections_with_1[shape2.get_path()] = intersection_shape
	intersection_pieces[shape1.get_path()] = intersections_with_1

func _process(delta):
	if Input.is_action_just_pressed("ui_focus_prev"):
		# Shift+tab
		select_previous_circle()
		pass
	elif Input.is_action_just_pressed("ui_focus_next"):
		# Tab
		select_next_circle()
		pass
	elif Input.is_action_just_pressed("ui_accept"):
		click_current_circle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for circle in get_tree().get_nodes_in_group('circles'):
		for shape in get_tree().get_nodes_in_group('shapes'):
			mark_intersections(circle, shape)
		circle.set_complete(calculate_complete(circle))

func mark_intersections(circle: Node2D, shape2: Node2D):
	var intersection_marker = intersection_pieces[circle.get_path()][shape2.get_path()]
	var intersections = Geometry.intersect_polygons_2d(
		get_polygon_global_coords(circle), get_polygon_global_coords(shape2))
	if intersections.size() > 0:
		#print(intersections)
		intersection_marker.set_polygon(intersections[0])
		# TODO check if intersection_marker makes the level complete and flag circle if so
		#if does_complete_circle(circle, shape2, intersection_marker):
		#	circle.set_complete(true)
			# TODO handle no longer being complete
	else:
		#print('No intersection')
		intersection_marker.set_polygon(PoolVector2Array())

	pass

func _on_IntersectionMarker_input_event(viewport, event, shape_idx):
	pass

func get_polygon_global_coords(shape: Node2D):
	if not shape.has_method('get_polygon'): return
	var result = PoolVector2Array()
	for point in shape.get_polygon():
		result.append(point + shape.position)
	return result

func _on_NextLevelButton_pressed():
	# TODO fade
	get_tree().change_scene("res://Level4.tscn")

func calculate_complete(circle: Node2D):
	var pieces = intersection_pieces[circle.get_path()]
	for shape in pieces.keys():
		#print('Checking ' + shape)
		# Check correct colour, allowing for floating point rounding
		if not pieces[shape].get_colour().is_equal_approx(Colours.ANSWER_RED):
			#print('Wrong colour')
			continue

		# Check intersection
		var first = get_polygon_global_coords(circle)
		var second = get_polygon_global_coords(get_node(shape))
		var difference = Geometry.clip_polygons_2d(first, second)
		#print(first)
		#print(second)
		#print(difference)
		if difference.empty():
			return true
			#print('Completed level!')
			#$LevelCompleteUI.show()
		else:
			continue
			#print('No intersection')
	return false

func complete_level():
	print('Completed level!')
	$LevelCompleteUI.show()
	$LevelCompleteUI/NextLevelButton.grab_focus()

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
		if all_circles_popped():
			complete_level()

func _on_OrangeCircle_clicked():
	click_circle($OrangeCircle)

func _on_RedCircle_clicked():
	click_circle($RedCircle)

func _on_GoldCircle_clicked():
	click_circle($GoldCircle)

func _on_PinkCircle_clicked():
	click_circle($PinkCircle)

func _on_BlueCircle_clicked():
	click_circle($BlueCircle)

