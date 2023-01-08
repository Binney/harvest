extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var line = get_node('Line2D') as Line2D
	if not line: return
	print('Ready for line!')
	var points = PoolVector2Array()
	for i in line.points.size():
		# TODO proper normal
		var this_segment = line.points[(i + 1) % line.points.size()] - line.points[i]
		var diff = this_segment.normalized().rotated(PI / 2) * line.width / 2
		points.append(line.points[i] + diff)
		pass
	for i in line.points.size(): # Go backwards so the shape's convex
		var this_segment = line.points[(-i - 1) % line.points.size()] - line.points[-i]
		var diff = this_segment.normalized().rotated(PI / 2) * line.width / 2
		#Vector2(line.width / 2, 0).rotated(atan(this_segment.y / this_segment.x))
		points.append(line.points[-i - 1] + diff)
		pass
	$CollisionPolygon2D.polygon = points

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var line = get_node('Line2D') as Line2D
	if not line: return


