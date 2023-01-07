extends Node2D

var shape_scene = preload('IntersectionShape.tscn')
var intersection_pieces = {}

func _ready():
	$LevelCompleteUI.hide()
	for shape in get_tree().get_nodes_in_group('shapes'):
		var intersection_shape = shape_scene.instance()
		intersection_shape.set_colour(Color(0,0,0))
		# Empty polygon until first physics_process
		add_child(intersection_shape)
		intersection_pieces[shape.get_path()] = intersection_shape

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for shape in get_tree().get_nodes_in_group('shapes'):
		mark_intersections($Dinsky, shape)
	pass

func mark_intersections(shape1: Node2D, shape2: Node2D):
	#print('Marking intersections between ' + shape1.get_path() + ' and ' + shape2.get_path())
	var intersection_marker = intersection_pieces[shape2.get_path()]
	var intersections = Geometry.intersect_polygons_2d(
		get_polygon_global_coords(shape1), get_polygon_global_coords(shape2))
	if intersections.size() > 0:
		#print(intersections)
		intersection_marker.set_polygon(intersections[0])
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


func _on_Tri2Intersection_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print('Clicked the intersection! check if complete intersection and complete level')
		# TODO make this programmatic: any triangle/shape that makes the protagonist entirely red, works
		var difference = Geometry.clip_polygons_2d(
			get_polygon_global_coords($Dinsky), get_polygon_global_coords($Triangle2))
		if difference.empty():
			# Circle completely within triangle
			print('Completed level!')
			$LevelCompleteUI.show()


func _on_Dinsky_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print('Clicked circle! check if complete intersection and complete level')
		for intersection_area in intersection_pieces.values():
			print('Checking ' + intersection_area.get_path())
			# Check correct colour, allowing for floating point rounding
			if not intersection_area.get_colour().is_equal_approx(Color8(206, 41, 47)): # light red
				print('Wrong colour')
				continue

			# Check intersection
			var difference = Geometry.clip_polygons_2d(
				get_polygon_global_coords($Dinsky), get_polygon_global_coords(intersection_area))
			if difference.empty():
				print('Completed level!')
				$LevelCompleteUI.show()
			else:
				print('No intersection')

