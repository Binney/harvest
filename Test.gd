extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if Input.is_action_just_pressed("ui_right"):
#		var areaPolygon = PoolVector2Array()
#		print($Area2D.position)
#		for point in $Area2D/CollisionPolygon2D.polygon:
#			areaPolygon.append(point + $Area2D.position)
#		print(areaPolygon)
#		var kinematicPolygon = PoolVector2Array()
#		for point in $KinematicBody2D/Polygon2D.polygon:
#			kinematicPolygon.append(point + $KinematicBody2D.position)
#		var intersection = Geometry.intersect_polygons_2d(
#			areaPolygon,# - $Area2D.position,
#			kinematicPolygon)# - $KinematicBody2D.position)
#		#$Line2D.points = [Vector2(0, 100), Vector2(100, 0)]
#		$Line2D.points = intersection[0]
#		$IntersectionMarker.polygon = intersection[0]#.invert()
#		print(intersection)
	pass

func _physics_process(delta):
	var vh = 0
	var vv = 0
	if Input.is_action_pressed("ui_left"):
		vh = -1
	elif Input.is_action_pressed("ui_right"):
		vh = 1
	if Input.is_action_pressed("ui_up"):
		vv = -1
	elif Input.is_action_pressed("ui_down"):
		vv = 1
#	$IntersectionMarker.position += Vector2(vh, vv) * 10
#	print($IntersectionMarker.position)
	var collision_info = $KinematicBody2D.move_and_collide(Vector2(vh, vv) * 100 * delta)
	mark_intersections($KinematicBody2D, $Area2D)

func mark_intersections(_body1, _body2): # TODO actually use these
	var polygon1 = PoolVector2Array()
	for point in $Area2D/CollisionPolygon2D.polygon:
		polygon1.append(point + $Area2D.position)

	var polygon2 = PoolVector2Array()
	for point in $KinematicBody2D/Polygon2D.polygon:
		polygon2.append(point + $KinematicBody2D.position)

	var intersections = Geometry.intersect_polygons_2d(polygon1, polygon2)
	if intersections.size() > 0:
		$IntersectionMarker.polygon = intersections[0]
		# TODO cover higher order intersections / concave shapes


func _on_Area2D_body_entered(body):
#	var physics_body := body as PhysicsBody2D
#	if not physics_body: return
#	physics_body.
	pass # Replace with function body.
