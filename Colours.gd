extends Node

# Palette:
const TURQUOISE = '54a89b'
const BLUE = '05409c'
const DEEP_RED = '802325'
const GOLD = 'e9c97c'
const PINK = 'f1bcb5'
const ORANGE = 'd07b25'
const BLACK = '28282d'
const BG_COLOUR = 'e8dac2'

const ANSWER_RED = 'ce292f'

func mix_colours(colour1: Color, colour2: Color):
	print('Mixing ' + colour1.to_html(false) + ' and ' + colour2.to_html(false))
	# Colours in alphabetical order by hex code. Be sure to check your match is the right way around
	# too and put it both ways if you want to be on the safe side!
	var arr = [colour1.to_html(false), colour2.to_html(false)]
	arr.sort()
	print(arr)
	match arr:
		[TURQUOISE, DEEP_RED]:
			return BLUE
		[DEEP_RED, TURQUOISE]:
			return BLUE
		[DEEP_RED, GOLD]:
			return ANSWER_RED
		[TURQUOISE, PINK]:
			return ANSWER_RED
		[DEEP_RED, PINK]:
			return TURQUOISE
		[GOLD, PINK]:
			return BLUE
		[DEEP_RED, DEEP_RED]:
			return BG_COLOUR
		_:
			print('fallback')
			return BLACK
