
var _depth = gpu_get_depth()
gpu_set_depth(-0.1)
draw_sprite(sprite_index, state, x, y)
gpu_set_depth(_depth)