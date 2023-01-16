extends Node2D

tool

#export(Colours.SHAPE_COLOURS) var colour = Colours.SHAPE_COLOURS.BLACK setget set_colour, get_colour
var colour = 1

func set_colour(new_colour: int):
	colour = new_colour
	#print('Setting to ' + new_colour.to_html(false))
	$Polygon2D.color = Color(1, 1, 1) #Colours.to_hex(colour)

func get_colour():
	return colour

func set_polygon(polygon: PoolVector2Array):
	$CollisionPolygon2D.polygon = polygon
	$Polygon2D.polygon = polygon

func get_polygon():
	return $CollisionPolygon2D.polygon

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
