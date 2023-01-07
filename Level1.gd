extends Node2D

func _ready():
	$LevelCompleteUI.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	mark_intersections($Dinsky, $Triangle1, $Tri1Intersection)
	mark_intersections($Dinsky, $Triangle2, $Tri2Intersection)
	mark_intersections($Dinsky, $Triangle3, $Tri3Intersection)
	pass

func mark_intersections(shape1: Node2D, shape2: Node2D, intersection_marker: Node2D):
	var intersections = Geometry.intersect_polygons_2d(transform_to_map(shape1), transform_to_map(shape2))
	if intersections.size() > 0:
		intersection_marker.set_shape(intersections[0])
	else:
		intersection_marker.set_shape(PoolVector2Array())
#	# TODO cover higher order intersections / concave shapes


func _on_IntersectionMarker_input_event(viewport, event, shape_idx):
	pass

func transform_to_map(shape: Node2D):
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
		var difference = Geometry.clip_polygons_2d(transform_to_map($Dinsky), transform_to_map($Triangle2))
		if difference.empty():
			# Circle completely within triangle
			print('Completed level!')
			$LevelCompleteUI.show()
