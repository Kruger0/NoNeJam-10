
state = 0

if (place_meeting(x, y, obj_char2)) {
	state = 1
}

height = lerp(height, state, 0.1)