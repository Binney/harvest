extends RigidBody2D

export var polygon: PoolVector2Array setget set_polygon, get_polygon
export var colour: Color = Color8(62, 155, 137) setget set_colour, get_colour

func get_polygon():
	return $Polygon2D.polygon

# Called when the node enters the scene tree for the first time.
func set_polygon(new_polygon):
	polygon = new_polygon
	$CollisionPolygon2D.polygon = polygon
	$Polygon2D.polygon = polygon

func set_colour(new_colour: Color):
	colour = new_colour
	$Polygon2D.color = colour

func get_colour():
	return colour
