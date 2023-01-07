extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#mark_intersections()
	pass

func mark_intersections():
	var polygon1 = PoolVector2Array()
	for point in $Dinsky.get_polygon():
		polygon1.append(point + $Dinsky.position)

	var polygon2 = PoolVector2Array()
	for point in $Triangle.get_polygon():
		polygon2.append(point + $Triangle.position)

	var intersections = Geometry.intersect_polygons_2d(polygon1, polygon2)
	#if intersections.size() > 0: # TODO remove this as we still need to set the intersections to 0
	#	$IntersectionMarker/Polygon2D.polygon = intersections[0]
	#	$IntersectionMarker/CollisionPolygon2D.polygon = intersections[0]
	#	print($IntersectionMarker/CollisionPolygon2D.polygon)
		# TODO cover higher order intersections / concave shapes


func _on_IntersectionMarker_input_event(viewport, event, shape_idx):
	print('Event heard')
	if event.pressed:
		print('Clicked the intersection! check if complete intersection and complete level')
	pass # Replace with function body.

