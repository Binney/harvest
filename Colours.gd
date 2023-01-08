extends Node

# Palette:
const TURQUOISE = '54a89b'
const DEEP_RED = '802325'
const PINK = 'f1bcb5'
const BLUE = '05409c'
const GOLD = 'e9c97c'
const ORANGE = 'd07b25'

const PALETTE = [TURQUOISE, DEEP_RED, PINK, BLUE, GOLD, ORANGE]

const BLACK = '28282d'
const BG_COLOUR = 'e8dac2'

const ANSWER_RED = 'ce292f'

func mix_colours(colour1: Color, colour2: Color):
	print('Mixing ' + colour1.to_html(false) + ' and ' + colour2.to_html(false))
	# Colours in alphabetical order by hex code. Be sure to check your match is the right way around
	# too and put it both ways if you want to be on the safe side!
	var arr = [colour1.to_html(false), colour2.to_html(false)]
	arr.sort_custom(self, 'colour_order')
	match arr:
		[TURQUOISE, TURQUOISE]:
			return BG_COLOUR
		[TURQUOISE, DEEP_RED]:
			return BLUE
		[TURQUOISE, PINK]:
			return ANSWER_RED
		[TURQUOISE, BLUE]:
			return GOLD
		[TURQUOISE, GOLD]:
			return ORANGE
		[TURQUOISE, ORANGE]:
			return DEEP_RED

		[DEEP_RED, DEEP_RED]:
			return BG_COLOUR
		[DEEP_RED, PINK]:
			return TURQUOISE
		[DEEP_RED, BLUE]:
			return ORANGE
		[DEEP_RED, GOLD]:
			return ANSWER_RED
		[DEEP_RED, ORANGE]:
			return PINK

		[PINK, PINK]:
			return BG_COLOUR
		[PINK, BLUE]:
			return DEEP_RED
		[PINK, GOLD]:
			return BLUE
		[PINK, ORANGE]:
			return GOLD

		[BLUE, BLUE]:
			return BG_COLOUR
		[BLUE, GOLD]:
			return PINK
		[BLUE, ORANGE]:
			return ANSWER_RED

		[GOLD, GOLD]:
			return BG_COLOUR
		[GOLD, ORANGE]:
			return TURQUOISE

		[ORANGE, ORANGE]:
			return BG_COLOUR

		_:
			print('fallback')
			return BLACK

func get_rand_colour():
	return PALETTE[randi() % 7]

func colour_order(a, b):
	return PALETTE.find(a) < PALETTE.find(b)
