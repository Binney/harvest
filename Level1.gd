extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$LevelCompleteUI.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	mark_intersections()
	pass

func mark_intersections():
	var intersections = Geometry.intersect_polygons_2d(transform_to_map($Dinsky), transform_to_map($Triangle))
	if intersections.size() > 0: # TODO remove this as we still need to set the intersections to 0
		$IntersectionMarker/Polygon2D.polygon = intersections[0]
		$IntersectionMarker/CollisionPolygon2D.set_polygon(intersections[0])
	else:
		$IntersectionMarker/Polygon2D.polygon.empty()
		$IntersectionMarker/CollisionPolygon2D.polygon.empty()
#	# TODO cover higher order intersections / concave shapes


func _on_IntersectionMarker_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print('Clicked the intersection! check if complete intersection and complete level ' + str(randf()))
		var difference = Geometry.clip_polygons_2d(transform_to_map($Dinsky), transform_to_map($Triangle))
		if difference.empty():
			# Circle completely within triangle
			print('Completed level!')
			$LevelCompleteUI.show()
			pass
	pass # Replace with function body.

func transform_to_map(shape: Node2D):
	if not shape.has_method('get_polygon'): return
	var result = PoolVector2Array()
	for point in shape.get_polygon():
		result.append(point + shape.position)
	return result


func _on_NextLevelButton_pressed():
	# TODO fade
	get_tree().change_scene("res://Level2.tscn")
