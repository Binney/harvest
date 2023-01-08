extends StaticBody2D

tool

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var line = get_node('Line2D') as Line2D
	if not line: return
	var points = PoolVector2Array()
	for point in line.points:
		# TODO proper normal
		points.push_back(point + Vector2(line.width / 2, 0))
	for i in line.points.size(): # Go backwards so the shape's convex
		points.append(line.points[-i - 1] - Vector2(line.width / 2, 0))
	#points.append(line.get_point_position(0))
	$CollisionPolygon2D.polygon = points
	$Polygon2D.polygon = points
