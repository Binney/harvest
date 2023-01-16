extends Node2D

tool

var shape_scene = preload('IntersectionShape.tscn')

enum colours {
	TURQUOISE,
	DEEP_RED,
	PINK,
	BLUE,
	GOLD,
	ORANGE,
	BLACK,
	BG_COLOUR,
	ANSWER_RED,
	FINAL_WHITE
}

func to_hex(enum_colour: int):
	match enum_colour:
		colours.TURQUOISE:
			return '54a89b'
		colours.DEEP_RED:
			return '802325'
		colours.PINK:
			return 'f1bcb5'
		colours.BLUE:
			return '05409c'
		colours.GOLD:
			return 'e9c97c'
		colours.ORANGE:
			return 'd07b25'
		colours.BLACK:
			return '28282d'
		colours.BG_COLOUR:
			return 'e8dac2'
		colours.ANSWER_RED:
			return 'ce292f'
		colours.FINAL_WHITE:
			return 'f4f1e4'
		_:
			return '28282d' # Black

func mix_colours(colour1: int, colour2: int):
	var arr = [colour1, colour2]
	arr.sort()
	match arr:
		[colours.TURQUOISE, colours.TURQUOISE]:
			return colours.BG_COLOUR
		[colours.TURQUOISE, colours.DEEP_RED]:
			return colours.BLUE
		[colours.TURQUOISE, colours.PINK]:
			return colours.ANSWER_RED
		[colours.TURQUOISE, colours.BLUE]:
			return colours.GOLD
		[colours.TURQUOISE, colours.GOLD]:
			return colours.ORANGE
		[colours.TURQUOISE, colours.ORANGE]:
			return colours.DEEP_RED

		[colours.DEEP_RED, colours.DEEP_RED]:
			return colours.BG_COLOUR
		[colours.DEEP_RED, colours.PINK]:
			return colours.TURQUOISE
		[colours.DEEP_RED, colours.BLUE]:
			return colours.ORANGE
		[colours.DEEP_RED, colours.GOLD]:
			return colours.ANSWER_RED
		[colours.DEEP_RED, colours.ORANGE]:
			return colours.PINK

		[colours.PINK, colours.PINK]:
			return colours.BG_COLOUR
		[colours.PINK, colours.BLUE]:
			return colours.DEEP_RED
		[colours.PINK, colours.GOLD]:
			return colours.BLUE
		[colours.PINK, colours.ORANGE]:
			return colours.GOLD

		[colours.BLUE, colours.BLUE]:
			return colours.BG_COLOUR
		[colours.BLUE, colours.GOLD]:
			return colours.PINK
		[colours.BLUE, colours.ORANGE]:
			return colours.ANSWER_RED

		[colours.GOLD, colours.GOLD]:
			return colours.BG_COLOUR
		[colours.GOLD, colours.ORANGE]:
			return colours.TURQUOISE

		[colours.ORANGE, colours.ORANGE]:
			return colours.BG_COLOUR

		[colours.DEEP_RED, colours.FINAL_WHITE]:
			return colours.FINAL_WHITE

		_:
			print('fallback ' + str(colour1) + ', ' + str(colour2))
			return colours.BLACK

func redraw_intersections():
	print('Drawing intersections')
	clear_intersections()
	var level_shapes = get_tree().get_nodes_in_group('level_shapes')
	# TODO handle nth level intersections between the intersections themselves
	# do this as
	# - add non-intersecting bits too (clip_polygons_2d)
	# - then iterate over entire intersection array to add next triangle
	for shape in level_shapes:
		add_intersection_pieces_for(shape)
		pass
#		for j in range(i + 1, level_shapes.size()):
#			print("Matching " + str(i) + " with " + str(j))
#			var a = get_polygon_global_coords(level_shapes[i])
#			var b = get_polygon_global_coords(level_shapes[j])
#			draw_intersection(a, b)
#			draw_difference(a, b)
#			pass
	pass

func clear_intersections():
	for node in get_tree().get_nodes_in_group('intersection_pieces'):
		node.queue_free()

func add_intersection_pieces_for(shape):
	# TODO
	# - Keep running count of all area counted so far
	# - Subtract off at the end and add remainder too
	var running_total = []
	for node in get_tree().get_nodes_in_group('intersection_pieces'):
		var a = get_polygon_global_coords(shape)
		var b = get_polygon_global_coords(node)
		var colour = mix_colours(shape.get_colour(), node.get_colour())
		draw_intersection(a, b, colour)
		# TODO also cut out the corresponding bit of `node`
		var diff = Geometry.clip_polygons_2d(a, b)
		running_total.push_back(diff)
	var area_covered = PoolVector2Array()
	for polygon in running_total:
		area_covered = Geometry.merge_polygons_2d(area_covered, polygon)
	var remainder = Geometry.clip_polygons_2d(shape.get_polygon(), area_covered)
	if !remainder.empty():
		print("Not empty, drawing")
		spawn_intersection_at(remainder, shape.get_colour())

func get_polygon_global_coords(shape: Node2D):
	if not shape.has_method('get_polygon'): return
	var result = PoolVector2Array()
	var transform = shape.get_global_transform()
	for point in shape.get_polygon():
		result.append(transform.xform(point))
	return result

func draw_intersection(a: PoolVector2Array, b: PoolVector2Array, colour: int):
	var intersections = Geometry.intersect_polygons_2d(a, b)
	print(intersections)
	if intersections.size() > 0:
		for intersection in intersections:
			spawn_intersection_at(intersection, colour)

func draw_difference(a: PoolVector2Array, b: PoolVector2Array):
	var a_difference = Geometry.clip_polygons_2d(a, b)
	if a_difference.size() > 0:
		for polygon in a_difference:
			pass#spawn_intersection_at(polygon, Color(0, 1, 0))
	var b_difference = Geometry.clip_polygons_2d(b, a)
	if b_difference.size() > 0:
		for polygon in b_difference:
			pass#spawn_intersection_at(polygon, Color(0, 0, 1))

func spawn_intersection_at(polygon: PoolVector2Array, colour: int):
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

func _on_TriangleC_shape_changed():
	print("Triangle C changed shape!")
	redraw_intersections()
