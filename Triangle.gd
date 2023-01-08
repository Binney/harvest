extends RigidBody2D

export var polygon: PoolVector2Array setget set_polygon, get_polygon
export(Colours.SHAPE_COLOURS) var colour = Colours.SHAPE_COLOURS.TURQUOISE setget set_colour, get_colour

func get_polygon():
	return $Polygon2D.polygon

# Called when the node enters the scene tree for the first time.
func set_polygon(new_polygon):
	polygon = new_polygon
	$CollisionPolygon2D.polygon = polygon
	$Polygon2D.polygon = polygon

func set_colour(new_colour: int):
	colour = new_colour
	$Polygon2D.color = Colours.to_hex(colour)

func get_colour():
	return colour
