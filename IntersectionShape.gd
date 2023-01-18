extends Area2D

tool

enum colours {
	TURQUOISE,
	DEEP_RED,
	PINK,
	BLUE,
	GOLD,
	ORANGE,
	BLACK,
	BG_COLOUR,
	ANSWER_RED,
	FINAL_WHITE
}

func to_hex(enum_colour: int):
	match enum_colour:
		colours.TURQUOISE:
			return '54a89b'
		colours.DEEP_RED:
			return '802325'
		colours.PINK:
			return 'f1bcb5'
		colours.BLUE:
			return '05409c'
		colours.GOLD:
			return 'e9c97c'
		colours.ORANGE:
			return 'd07b25'
		colours.BLACK:
			return '28282d'
		colours.BG_COLOUR:
			return 'e8dac2'
		colours.ANSWER_RED:
			return 'ce292f'
		colours.FINAL_WHITE:
			return 'f4f1e4'
		_:
			return '28282d' # Black

export (colours) var colour = colours.BLACK setget set_colour, get_colour
export var shape: PoolVector2Array
#export(Colours.SHAPE_COLOURS) var colour = Colours.SHAPE_COLOURS.BLACK setget set_colour, get_colour

func set_colour(new_colour: int):
	colour = new_colour
	print("Set colour to #" + to_hex(new_colour))
	$Polygon2D.color = Color(to_hex(new_colour))

func get_colour():
	return colour

func set_polygon(polygon: PoolVector2Array):
	print('Setting polygon to:')
	print(polygon)
	$CollisionPolygon2D.polygon = polygon
	$Polygon2D.polygon = polygon
	shape = polygon

func get_polygon():
	return $CollisionPolygon2D.polygon

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
