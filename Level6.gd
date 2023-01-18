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

var intersection_pieces = {}

func _ready():
	redraw_level()
	for shape in get_tree().get_nodes_in_group('calculated_shapes'):
		shape.connect('body_entered', self, '_on_body_entered', [shape])
		shape.connect('body_exited', self, '_on_body_exited', [shape])

func _on_body_entered(circle, shape):
	# TODO spawn intersection piece between circle and shape
	# use dictionary
	print('Body entered')
	print(circle)
	print(shape)
	if !intersection_pieces.has(circle.get_path()):
		intersection_pieces[circle.get_path()] = {}
	intersection_pieces[circle.get_path()][shape.get_path()] = 1

func _on_body_exited(circle, shape):
	# TODO lookup intersection piece between circle and shape in dictionary
	# and delete it
	print('Body exited')
	print(circle)
	print(shape)
	intersection_pieces[circle.get_path()].erase(shape.get_path())

func _physics_process(delta):
	# TODO redraw all intersection pieces
	# TODO mark circle as complete if needed
	pass

func redraw_level():
	clear_intersections()
	for shape in get_tree().get_nodes_in_group('level_shapes'):
		print('Drawing intersections for ' + str(shape))
		add_calculated_shapes_for(shape)

func clear_intersections():
	for node in get_tree().get_nodes_in_group('calculated_shapes'):
		node.remove_from_group('calculated_shapes')
		node.queue_free()

func add_calculated_shapes_for(shape):
	var areas_left = [shape.get_polygon()]
	for node in get_tree().get_nodes_in_group('calculated_shapes'):
		var a = get_polygon_global_coords(shape)
		var b = get_polygon_global_coords(node)
		var colour = mix_colours(shape.get_colour(), node.get_colour())
		draw_intersection(a, b, colour)

		var node_sub = Geometry.clip_polygons_2d(b, a)
		for section in node_sub:
			spawn_intersection_at(section, node.get_colour())
		node.remove_from_group('calculated_shapes')
		node.queue_free()

		var new_areas_left = []
		for area in areas_left:
			new_areas_left.append_array(Geometry.clip_polygons_2d(area, b))
		areas_left = new_areas_left
	if !areas_left.empty():
		print('Drawing remaining areas')
		for section in areas_left:
			print(section)
			spawn_intersection_at(section, shape.get_colour())

func get_polygon_global_coords(shape: Node2D):
	if not shape.has_method('get_polygon'):
		return
	var result = PoolVector2Array()
	var transform = shape.get_global_transform()
	for point in shape.get_polygon():
		result.append(transform.xform(point))
	return result

func draw_intersection(a: PoolVector2Array, b: PoolVector2Array, colour: int):
	var intersections = Geometry.intersect_polygons_2d(a, b)
	if intersections.size() > 0:
		for intersection in intersections:
			spawn_intersection_at(intersection, colour)

func spawn_intersection_at(polygon: PoolVector2Array, colour: int):
	print('Spawning at ' + str(polygon))
	var intersection_marker = shape_scene.instance()
	intersection_marker.set_colour(colour)
	intersection_marker.set_polygon(polygon)
	intersection_marker.add_to_group('calculated_shapes')
	add_child(intersection_marker)
	# TODO reenable/get working in editor
	#intersection_marker.set_owner(get_tree().get_edited_scene_root())


func _on_TriangleA_shape_changed():
	print("Triangle A changed shape!")
	redraw_level()

func _on_TriangleB_shape_changed():
	print("Triangle B changed shape!")
	redraw_level()

func _on_TriangleC_shape_changed():
	print("Triangle C changed shape!")
	redraw_level()
