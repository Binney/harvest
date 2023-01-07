extends Node2D

var shape_scene = preload('IntersectionShape.tscn')
var intersection_pieces = {}

func _ready():
	$LevelCompleteUI.hide()
	for shape in get_tree().get_nodes_in_group('shapes'):
		add_intersection($Kan, shape)
		add_intersection($Dinsky, shape)

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for shape in get_tree().get_nodes_in_group('shapes'):
		mark_intersections($Dinsky, shape)
		mark_intersections($Kan, shape)
	if calculate_complete($Dinsky):
		$Dinsky.set_complete(true)
	else:
		$Dinsky.set_complete(false)
	if calculate_complete($Kan):
		$Kan.set_complete(true)
	else:
		$Kan.set_complete(false)
	pass

func mark_intersections(circle: Node2D, shape2: Node2D):
	#print('Marking intersections between ' + circle.get_path() + ' and ' + shape2.get_path())
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
	get_tree().change_scene("res://Level3.tscn")

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



func _on_Dinsky_mouse_entered():
	if $Dinsky.is_complete():
		$Dinsky.highlight_line()

func _on_Dinsky_mouse_exited():
	$Dinsky.deselect_line()
	pass # Replace with function body.

func complete_level():
	print('Completed level!')
	$LevelCompleteUI.show()

func _on_Kan_mouse_entered():
	if $Kan.is_complete():
		$Kan.highlight_line()

func _on_Kan_mouse_exited():
	$Kan.deselect_line()


func _on_Dinsky_clicked():
	$Dinsky.selected = true
	$Kan.selected = false
	if $Dinsky.is_complete():
		$Dinsky.pop()
		for piece in intersection_pieces[$Dinsky.get_path()].values():
			piece.hide()
		if $Kan.popped:
			complete_level()

func _on_Kan_clicked():
	$Kan.selected = true
	$Dinsky.selected = false
	if $Kan.is_complete():
		$Kan.pop()
		for piece in intersection_pieces[$Kan.get_path()].values():
			piece.hide()
		if $Dinsky.popped:
			complete_level()