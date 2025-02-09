


application_surface_draw_enable(false)
cam = view_camera[0]
angle = 0

scl = {
	cam : 1.0,
	gui : 1.0,
	win : 2.0,
	aps : 4.0,
}

cam_wid = GAME_WID*scl.cam
cam_hei = GAME_HEI*scl.cam

surf_light = -1
ambient_light = #EFEFEF

//==============================// Update //=================================

display_set_gui_size(GAME_WID*scl.gui, GAME_HEI*scl.gui)
window_set_size(GAME_WID*scl.win, GAME_HEI*scl.win)
surface_resize(application_surface, GAME_WID*scl.aps, GAME_HEI*scl.aps)

alarm[0] = 1 // window center

asp_ratio = GAME_WID/ GAME_HEI

//==============================// Follow //=================================

follow_obj		= obj_player
follow_pos		= new Vector2(16, 16)
follow_offset	= new Vector2()

track_spd		= 0.1
track_offset	= new Vector2(0, -16)

//==============================// Shake //=================================

shake			= false;
shake_time		= 0;
shake_timestart = 0
shake_hor_mag	= 0;
shake_ver_mag	= 0;
shake_magnitude = 0;
shake_falloff	= 0;
shake_speed		= 0
shake_rotation	= 0
shake_xoff		= 0
shake_yoff		= 0
shake_angoff	= 0;
shake_target	= 0;

//==============================// Transition //=================================

enum TranStt {
	Idle,
	In,
	Out,
}

tran_state			= TranStt.Idle
tran_progress		= 0
tran_middle_delay	= 10
tran_middle_time	= 0
tran_spd			= 0
tran_col			= c_black
tran_from			= -1
tran_to				= -1
tran_type			= 0
tran_mask_tex		= sprite_get_texture(spr_grayscale_transition, tran_type)
tran_mask_uv		= sprite_get_uvs(spr_grayscale_transition, tran_type)
tran_fake			= false
tran_callback		= undefined

//==============================// Functions //=================================

screenshake_fx = function() {
	shake_time = max(shake_time-1, 0);
	if (shake_time > 1) {
		var _shk_fac = shake_time/shake_timestart;
		var _shk_pow = power(_shk_fac, 3);
		
		// Just random constants. It can be whatever you want
		var _x = noise_get(846+(global.gametime*shake_speed)) * shake_hor_mag;
		var _y = noise_get(128+(global.gametime*shake_speed)) * shake_ver_mag;
		var _r = noise_get(482+(global.gametime*shake_speed)) * shake_rotation;
		
		shake_xoff		= _x * _shk_pow;
		shake_yoff		= _y * _shk_pow;
		shake_angoff	= _r * _shk_pow;
	} else {
		shake = false;
		shake_speed = 0;
		shake_timestart = 0;
		shake_magnitude = 0;
		shake_rotation = 0
	}
	x += shake_xoff;
	y += shake_yoff;
	angle += shake_angoff;
}


transition_apply = function() {
	var _progress = 0
	var _gui_w = display_get_gui_width()
	var _gui_h = display_get_gui_height()
	var _win_w = window_get_width()
	var _win_h = window_get_height()
	
	switch (tran_state) {
		case TranStt.Idle: {
			return;
		}
		break;
		
		case TranStt.In: {
			tran_progress++;
			_progress = tran_progress/(ROOM_SPEED*tran_spd)
			if (tran_progress >= ROOM_SPEED*tran_spd) {
				tran_progress = ROOM_SPEED*tran_spd;
				
				if (tran_middle_time < 1) {
					tran_middle_time = tran_middle_delay
				}
				
				tran_middle_time--;
				if (tran_middle_time < 1) {
					tran_middle_time = tran_middle_delay
					//if !(tran_fake) {
						if (room_exists(tran_to)) {
							room_goto(tran_to)
							ROOM_NAME = string_letters(room_get_name(tran_to))
							tran_reset_globals()
						}
					//} else {
						var _callback = tran_callback ?? function(){}
						_callback()
					//}
					tran_state = TranStt.Out
				}	
			}
		}
		break;
		
		case TranStt.Out: {
			tran_progress = max(tran_progress-1, 0)
			_progress = tran_progress/(ROOM_SPEED*tran_spd)
			if (tran_progress < 1) { // reset tran data
				tran_state = TranStt.Idle
				tran_progress = 0
				tran_from = -1
				tran_to = -1
				tran_spd = 0
				tran_col = c_black
				tran_type		= 0
				tran_mask_tex	= sprite_get_texture(spr_grayscale_transition, tran_type)
				tran_mask_uv	= sprite_get_uvs(spr_grayscale_transition, tran_type)
				tran_fake		= false
				tran_callback	= undefined
				exit;
			}
		}
		break;
	}
	
	var _shd = shd_cam_transition
	var _col = tran_col
	shader_set(_shd)	
	
	// mask sprite
	var _u_mask_tex = shader_get_sampler_index(_shd, "u_mask_tex");
	texture_set_stage(_u_mask_tex, tran_mask_tex)
	
	// mask uvs
	var _u_mask_uv = shader_get_uniform(_shd, "u_mask_uv");
	shader_set_uniform_f(_u_mask_uv, tran_mask_uv[0], tran_mask_uv[1], tran_mask_uv[2], tran_mask_uv[3])
	
	// color
	var _u_tran_col = shader_get_uniform(_shd, "u_color")	
	var _col_arr = [color_get_red(_col)/255, color_get_green(_col)/255, color_get_blue(_col)/255]
	shader_set_uniform_f_array(_u_tran_col, _col_arr)
	
	// progress factor
	var _u_progress = shader_get_uniform(_shd, "u_progress")	
	shader_set_uniform_f(_u_progress, power(_progress, 2))
	
	
	draw_sprite_stretched_ext(spr_grayscale_transition, tran_type, 0, 0, GUI_WID, GUI_HEI, tran_col, 1)
	shader_reset()
}
