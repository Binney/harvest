extends Node2D

tool

var shape_scene = preload('IntersectionShape.tscn')

func redraw_intersections():
	clear_intersections()
	var level_shapes = get_tree().get_nodes_in_group('level_shapes')
	# TODO handle nth level intersections between the intersections themselves
	# do this as
	# - add non-intersecting bits too (clip_polygons_2d)
	# - then iterate over entire intersection array to add next triangle
	for i in range(level_shapes.size() - 1):
		for j in range(i + 1, level_shapes.size()):
			print("Matching " + str(i) + " with " + str(j))
			var a = get_polygon_global_coords(level_shapes[i])
			var b = get_polygon_global_coords(level_shapes[j])
			draw_intersection(a, b)
			draw_difference(a, b)
			pass
	pass

func clear_intersections():
	for node in get_tree().get_nodes_in_group('intersection_pieces'):
		node.queue_free()

func draw_intersection(a, b):
	var intersections = Geometry.intersect_polygons_2d(a, b)
	print(intersections)
	if intersections.size() > 0:
		for intersection in intersections:
			spawn_intersection_at(intersection, Color(1, 0, 0))

func draw_difference(a, b):
	var a_difference = Geometry.clip_polygons_2d(a, b)
	if a_difference.size() > 0:
		for polygon in a_difference:
			spawn_intersection_at(polygon, Color(0, 1, 0))
	var b_difference = Geometry.clip_polygons_2d(b, a)
	if b_difference.size() > 0:
		for polygon in b_difference:
			spawn_intersection_at(polygon, Color(0, 0, 1))

func get_polygon_global_coords(shape: Node2D):
	if not shape.has_method('get_polygon'): return
	var result = PoolVector2Array()
	var transform = shape.get_global_transform()
	for point in shape.get_polygon():
		result.append(transform.xform(point))
	return result

func spawn_intersection_at(polygon, colour):
	var intersection_marker = shape_scene.instance()
	intersection_marker.set_colour(colour)
	#intersection_marker.set_colour(Colours.SHAPE_COLOURS.PINK)
	intersection_marker.set_polygon(polygon)
	intersection_marker.add_to_group('intersection_pieces')
	add_child(intersection_marker)

func _on_TriangleA_shape_changed():
	print("Triangle A changed shape!")
	redraw_intersections()

func _on_TriangleB_shape_changed():
	print("Triangle B changed shape!")
	redraw_intersections()
