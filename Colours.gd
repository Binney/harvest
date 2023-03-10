extends Node

enum SHAPE_COLOURS {
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
		SHAPE_COLOURS.TURQUOISE:
			return '54a89b'
		SHAPE_COLOURS.DEEP_RED:
			return '802325'
		SHAPE_COLOURS.PINK:
			return 'f1bcb5'
		SHAPE_COLOURS.BLUE:
			return '05409c'
		SHAPE_COLOURS.GOLD:
			return 'e9c97c'
		SHAPE_COLOURS.ORANGE:
			return 'd07b25'
		SHAPE_COLOURS.BLACK:
			return '28282d'
		SHAPE_COLOURS.BG_COLOUR:
			return 'e8dac2'
		SHAPE_COLOURS.ANSWER_RED:
			return 'ce292f'
		SHAPE_COLOURS.FINAL_WHITE:
			return 'f4f1e4'
		_:
			return '28282d' # Black

func mix_colours(colour1: int, colour2: int):
	var arr = [colour1, colour2]
	arr.sort()
	match arr:
		[SHAPE_COLOURS.TURQUOISE, SHAPE_COLOURS.TURQUOISE]:
			return SHAPE_COLOURS.BG_COLOUR
		[SHAPE_COLOURS.TURQUOISE, SHAPE_COLOURS.DEEP_RED]:
			return SHAPE_COLOURS.BLUE
		[SHAPE_COLOURS.TURQUOISE, SHAPE_COLOURS.PINK]:
			return SHAPE_COLOURS.ANSWER_RED
		[SHAPE_COLOURS.TURQUOISE, SHAPE_COLOURS.BLUE]:
			return SHAPE_COLOURS.GOLD
		[SHAPE_COLOURS.TURQUOISE, SHAPE_COLOURS.GOLD]:
			return SHAPE_COLOURS.ORANGE
		[SHAPE_COLOURS.TURQUOISE, SHAPE_COLOURS.ORANGE]:
			return SHAPE_COLOURS.DEEP_RED

		[SHAPE_COLOURS.DEEP_RED, SHAPE_COLOURS.DEEP_RED]:
			return SHAPE_COLOURS.BG_COLOUR
		[SHAPE_COLOURS.DEEP_RED, SHAPE_COLOURS.PINK]:
			return SHAPE_COLOURS.TURQUOISE
		[SHAPE_COLOURS.DEEP_RED, SHAPE_COLOURS.BLUE]:
			return SHAPE_COLOURS.ORANGE
		[SHAPE_COLOURS.DEEP_RED, SHAPE_COLOURS.GOLD]:
			return SHAPE_COLOURS.ANSWER_RED
		[SHAPE_COLOURS.DEEP_RED, SHAPE_COLOURS.ORANGE]:
			return SHAPE_COLOURS.PINK

		[SHAPE_COLOURS.PINK, SHAPE_COLOURS.PINK]:
			return SHAPE_COLOURS.BG_COLOUR
		[SHAPE_COLOURS.PINK, SHAPE_COLOURS.BLUE]:
			return SHAPE_COLOURS.DEEP_RED
		[SHAPE_COLOURS.PINK, SHAPE_COLOURS.GOLD]:
			return SHAPE_COLOURS.BLUE
		[SHAPE_COLOURS.PINK, SHAPE_COLOURS.ORANGE]:
			return SHAPE_COLOURS.GOLD

		[SHAPE_COLOURS.BLUE, SHAPE_COLOURS.BLUE]:
			return SHAPE_COLOURS.BG_COLOUR
		[SHAPE_COLOURS.BLUE, SHAPE_COLOURS.GOLD]:
			return SHAPE_COLOURS.PINK
		[SHAPE_COLOURS.BLUE, SHAPE_COLOURS.ORANGE]:
			return SHAPE_COLOURS.ANSWER_RED

		[SHAPE_COLOURS.GOLD, SHAPE_COLOURS.GOLD]:
			return SHAPE_COLOURS.BG_COLOUR
		[SHAPE_COLOURS.GOLD, SHAPE_COLOURS.ORANGE]:
			return SHAPE_COLOURS.TURQUOISE

		[SHAPE_COLOURS.ORANGE, SHAPE_COLOURS.ORANGE]:
			return SHAPE_COLOURS.BG_COLOUR

		[SHAPE_COLOURS.DEEP_RED, SHAPE_COLOURS.FINAL_WHITE]:
			return SHAPE_COLOURS.FINAL_WHITE

		_:
			print('fallback ' + str(colour1) + ', ' + str(colour2))
			return SHAPE_COLOURS.BLACK

func get_rand_colour():
	return randi() % 6
