
if (string_letters(room_get_name(room)) == "rmlevel") {
	var _layer = "tile_walls"
	var _lay_id = layer_get_id(_layer)
	tilemap_y(layer_tilemap_get_id(_lay_id), global.yoff)
	
	tile_solidify(_layer, obj_wall)
	tile_liquidify("tile_water", obj_water)
	tile_liquidify("tile_poison", obj_poison)
	
	layer_set_visible(layer_get_id("grid"), false)
}

if (instance_exists(obj_char1) && instance_exists(obj_char2)) {
	if (global.current_char = -1) {
		global.current_char = obj_char1 // TODO ou random
	}
}