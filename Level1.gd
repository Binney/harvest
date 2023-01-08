extends Node2D

var shape_scene = preload('IntersectionShape.tscn')
var intersection_pieces = {}

func _ready():
	$LevelCompleteUI.hide()
	for shape in get_tree().get_nodes_in_group('shapes'):
		var intersection_shape = shape_scene.instance()
		var colour = Colours.mix_colours(shape.get_colour(), $Dinsky.get_colour())
		intersection_shape.set_colour(colour)
		# Empty polygon until first physics_process
		add_child(intersection_shape)
		intersection_pieces[shape.get_path()] = intersection_shape

func _process(delta):
	if Input.is_action_just_pressed("ui_focus_prev"):
		# Shift+tab
		$Dinsky.selected = true
		pass
	elif Input.is_action_just_pressed("ui_focus_next"):
		# Tab
		$Dinsky.selected = true
		pass
	elif Input.is_action_just_pressed("ui_accept"):
		print('clicked accept')
		click_current_circle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for shape in get_tree().get_nodes_in_group('shapes'):
		mark_intersections($Dinsky, shape)
	if is_complete($Dinsky):
		$Dinsky.set_complete(true)
	else:
		$Dinsky.set_complete(false)
	pass

func mark_intersections(circle: Node2D, shape2: Node2D):
	#print('Marking intersections between ' + circle.get_path() + ' and ' + shape2.get_path())
	var intersection_marker = intersection_pieces[shape2.get_path()]
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
	get_tree().change_scene("res://Level2.tscn")

func is_complete(circle: Node2D):
	for shape in intersection_pieces.keys():
		#print('Checking ' + shape)
		# Check correct colour, allowing for floating point rounding
		if intersection_pieces[shape].get_colour() != Colours.SHAPE_COLOURS.ANSWER_RED:
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
		for piece in intersection_pieces.values():
			piece.hide()
		if all_circles_popped():
			complete_level()


func _on_Dinsky_clicked():
	if not $Dinsky.selected:
		$IntroTextAnimationPlayer.play_backwards('Fade2')
		$IntroTextAnimationPlayer.queue('Fade1')
		$IntroTextAnimationPlayer.queue('Fade2')
		$Dinsky.selected = true
