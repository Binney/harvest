extends Node2D

tool

var shape_scene = preload('IntersectionShape.tscn')

func redraw_intersections():
	print("Redrawing intersections")
	clear_intersections()
	var level_shapes = get_tree().get_nodes_in_group('level_shapes')
	for i in range(level_shapes.size() - 1):
		for j in range(i + 1, level_shapes.size()):
			print("Matching " + str(i) + " with " + str(j))
			draw_intersection(level_shapes[i], level_shapes[j])
			pass
	pass

func clear_intersections():
	for node in get_tree().get_nodes_in_group('intersection_pieces'):
		node.queue_free()

func draw_intersection(a, b):
	var intersections = Geometry.intersect_polygons_2d(
		get_polygon_global_coords(a), get_polygon_global_coords(b))
	if intersections.size() > 0:
		print(intersections)
		for intersection in intersections:
			spawn_intersection_at(intersection)

func get_polygon_global_coords(shape: Node2D):
	print(shape)
	if not shape.has_method('get_polygon'): return
	var result = PoolVector2Array()
	var transform = shape.get_global_transform()
	for point in shape.get_polygon():
		result.append(transform.xform(point))
	return result

func spawn_intersection_at(polygon):
	print('Spawning at:')
	print(polygon)
	var intersection_marker = shape_scene.instance()
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
