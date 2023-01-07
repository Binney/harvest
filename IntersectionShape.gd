extends Node2D

export var colour: Color setget set_colour, get_colour

func set_colour(new_colour: Color):
	colour = new_colour
	$Polygon2D.color = colour

func get_colour():
	return colour

func set_polygon(polygon: PoolVector2Array):
	$CollisionPolygon2D.polygon = polygon
	$Polygon2D.polygon = polygon

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
