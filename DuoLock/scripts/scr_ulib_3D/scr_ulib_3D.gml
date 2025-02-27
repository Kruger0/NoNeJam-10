/*
// Default vertex format used bu ULib-GM. TODO: make it private
vertex_format_begin()
vertex_format_add_position_3d()
vertex_format_add_texcoord()
vertex_format_add_normal()
vertex_format_add_color()
global.vformmat = vertex_format_end()
#macro VFORMAT global.vformmat

function vertex_add_point(_vbuff, _x, _y, _z, _u, _v, _col = c_white, _alpha = 1, _nx = 0, _ny = 0, _nz = 0) {
	vertex_position_3d(_vbuff, _x, _y, _z)
	vertex_texcoord(_vbuff, _u, _v)
	vertex_normal(_vbuff, _nx, _ny, _nz)
	vertex_color(_vbuff, _col, _alpha)
}

function vertex_add_face(_vbuff, _pos1, _pos2, _pos3, _pos4, _uvs, _col = c_white, _a = 1) {
	vertex_add_point(_vbuff, _pos1[0], _pos1[1], _pos1[2], _uvs[0], _uvs[1], _col, _a)
	vertex_add_point(_vbuff, _pos2[0], _pos2[1], _pos2[2], _uvs[2], _uvs[1], _col, _a)
	vertex_add_point(_vbuff, _pos3[0], _pos3[1], _pos3[2], _uvs[0], _uvs[3], _col, _a)
	
	vertex_add_point(_vbuff, _pos2[0], _pos2[1], _pos2[2], _uvs[2], _uvs[1], _col, _a)
	vertex_add_point(_vbuff, _pos4[0], _pos4[1], _pos4[2], _uvs[2], _uvs[3], _col, _a)
	vertex_add_point(_vbuff, _pos3[0], _pos3[1], _pos3[2], _uvs[0], _uvs[3], _col, _a)
}

function vertex_create_model(_spr, _subimg = 0, _col = c_white, _a = 1, _clockwise = true) {
	
	var _info = sprite_get_info(_spr)
	var _uvs = sprite_get_uvs(_spr, _subimg)
	
	var _x1 = 0 - _info.xoffset
	var _y1 = 0 - _info.yoffset
	var _x2 = _info.width - _info.xoffset
	var _y2 = _info.height- _info.yoffset
	var _z = 0
	
	var _vbuffer = vertex_create_buffer()
	vertex_begin(_vbuffer, VFORMAT)
		if (_clockwise) {
			vertex_add_point(_vbuffer, _x1, _y1, _z, _uvs[0], _uvs[1], _col, _a)
			vertex_add_point(_vbuffer, _x1, _y2, _z, _uvs[0], _uvs[3], _col, _a)
			vertex_add_point(_vbuffer, _x2, _y1, _z, _uvs[2], _uvs[1], _col, _a)
																	   
			vertex_add_point(_vbuffer, _x1, _y2, _z, _uvs[0], _uvs[3], _col, _a)
			vertex_add_point(_vbuffer, _x2, _y2, _z, _uvs[2], _uvs[3], _col, _a)
			vertex_add_point(_vbuffer, _x2, _y1, _z, _uvs[2], _uvs[1], _col, _a)	
		} else {													   
			vertex_add_point(_vbuffer, _x1, _y1, _z, _uvs[0], _uvs[1], _col, _a)
			vertex_add_point(_vbuffer, _x2, _y1, _z, _uvs[2], _uvs[1], _col, _a)
			vertex_add_point(_vbuffer, _x1, _y2, _z, _uvs[0], _uvs[3], _col, _a)
																	   
			vertex_add_point(_vbuffer, _x2, _y1, _z, _uvs[2], _uvs[1], _col, _a)
			vertex_add_point(_vbuffer, _x2, _y2, _z, _uvs[2], _uvs[3], _col, _a)
			vertex_add_point(_vbuffer, _x1, _y2, _z, _uvs[0], _uvs[3], _col, _a)	
		}
	vertex_end(_vbuffer)
	vertex_freeze(_vbuffer)
	
	return _vbuffer
}

function vertex_build_cube(x1, y1, z1, x2, y2, z2, hrepeat, vrepeat, color=c_white, alpha=1) {
	var _vbuff = vertex_create_buffer();
	
	vertex_begin(_vbuff, VFORMAT);
	
	// top
	vertex_add_point(_vbuff, x1, y1, z2, 0, 0, 1, 0, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z2, 0, 0, 1, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z2, 0, 0, 1, 0, vrepeat, color, alpha);
	
	vertex_add_point(_vbuff, x2, y1, z2, 0, 0, 1, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z2, 0, 0, 1, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z2, 0, 0, 1, 0, vrepeat, color, alpha);
	
	// bottom
	vertex_add_point(_vbuff, x1, y2, z1, 0, 0, -1, 0, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z1, 0, 0, -1, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x1, y1, z1, 0, 0, -1, 0, 0, color, alpha);
	
	vertex_add_point(_vbuff, x1, y2, z1, 0, 0, -1, 0, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z1, 0, 0, -1, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z1, 0, 0, -1, hrepeat, 0, color, alpha);
	
	// front
	vertex_add_point(_vbuff, x1, y2, z2, 0, 1, 0, 0, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z1, 0, 1, 0, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z1, 0, 1, 0, 0, 0, color, alpha);
	
	vertex_add_point(_vbuff, x1, y2, z2, 0, 1, 0, 0, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z2, 0, 1, 0, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z1, 0, 1, 0, hrepeat, 0, color, alpha);
	
	// back
	vertex_add_point(_vbuff, x1, y1, z1, 0, -1, 0, 0, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z1, 0, -1, 0, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x1, y1, z2, 0, -1, 0, 0, vrepeat, color, alpha);
	
	vertex_add_point(_vbuff, x2, y1, z1, 0, -1, 0, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z2, 0, -1, 0, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x1, y1, z2, 0, -1, 0, 0, vrepeat, color, alpha);
	
	// right
	vertex_add_point(_vbuff, x2, y1, z1, 1, 0, 0, 0, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z1, 1, 0, 0, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z2, 1, 0, 0, 0, vrepeat, color, alpha);
	
	vertex_add_point(_vbuff, x2, y2, z1, 1, 0, 0, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x2, y2, z2, 1, 0, 0, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x2, y1, z2, 1, 0, 0, 0, vrepeat, color, alpha);
	
	// left
	vertex_add_point(_vbuff, x1, y1, z2, -1, 0, 0, 0, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z1, -1, 0, 0, hrepeat, 0, color, alpha);
	vertex_add_point(_vbuff, x1, y1, z1, -1, 0, 0, 0, 0, color, alpha);
	
	vertex_add_point(_vbuff, x1, y1, z2, -1, 0, 0, 0, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z2, -1, 0, 0, hrepeat, vrepeat, color, alpha);
	vertex_add_point(_vbuff, x1, y2, z1, -1, 0, 0, hrepeat, 0, color, alpha);
	
	// finalize VBO
	vertex_end(_vbuff);
	vertex_freeze(_vbuff);
	
	return _vbuff
};
	
function world_to_screen(_x, _y, _z, _view_mat, _proj_mat) {
	var _cx, _cy
	if (_proj_mat[15] == 0) {   //This is a perspective projection
	    var w = _view_mat[2] * _x + _view_mat[6] * _y + _view_mat[10] * _z + _view_mat[14];
	    // If you try to convert the camera's "from" position to screen space, you will
	    // end up dividing by zero (please don't do that)
	    //if (w <= 0) return [-1, -1];
	    if (w == 0) {
			return [-1, -1];
		}
		
		_cx = _proj_mat[8] + _proj_mat[0] * (_view_mat[0] * _x + _view_mat[4] * _y + _view_mat[8] * _z + _view_mat[12]) / w;
		_cy = _proj_mat[9] + _proj_mat[5] * (_view_mat[1] * _x + _view_mat[5] * _y + _view_mat[9] * _z + _view_mat[13]) / w;
	} else {    //This is an ortho projection
		_cx = _proj_mat[12] + _proj_mat[0] * (_view_mat[0] * _x + _view_mat[4] * _y + _view_mat[8]  * _z + _view_mat[12]);
		_cy = _proj_mat[13] + _proj_mat[5] * (_view_mat[1] * _x + _view_mat[5] * _y + _view_mat[9]  * _z + _view_mat[13]);
	}
	
	// Change the y math to + or - acording to yout up vector
	return {
		x : (0.5 + 0.5 * _cx) * window_get_width(), 
		y : (0.5 - 0.5 * _cy) * window_get_height()
	};
}

function screen_to_world_dimension(view_mat, proj_mat, xx, yy) {
	// credits: TheSnidr
	var _mx = 2 * (xx / window_get_width() - 0.5) / proj_mat[0];
	var _my = 2 * (yy / window_get_height() - 0.5) / proj_mat[5];
	var _cam_x = - (view_mat[12] * view_mat[0] + view_mat[13] * view_mat[1] + view_mat[14] * view_mat[2]);
	var _cam_y = - (view_mat[12] * view_mat[4] + view_mat[13] * view_mat[5] + view_mat[14] * view_mat[6]);
	var _cam_z = - (view_mat[12] * view_mat[8] + view_mat[13] * view_mat[9] + view_mat[14] * view_mat[10]);
	var _matrix = undefined; // [dx, dy, dz, ox, oy, oz]
	if (proj_mat[15] == 0) {
	// perspective projection
	_matrix = [view_mat[2]  + _mx * view_mat[0] + _my * view_mat[1],
			view_mat[6]  + _mx * view_mat[4] + _my * view_mat[5],
			view_mat[10] + _mx * view_mat[8] + _my * view_mat[9],
			_cam_x,
			_cam_y,
			_cam_z];
	} else {
	// orthographic projection
	_matrix = [view_mat[2],
			view_mat[6],
			view_mat[10],
			_cam_x + _mx * view_mat[0] + _my * view_mat[1],
			_cam_y + _mx * view_mat[4] + _my * view_mat[5],
			_cam_z + _mx * view_mat[8] + _my * view_mat[9]];
	}
	var _xx = _matrix[0] * _matrix[5] / -_matrix[2] + _matrix[3];
	var _yy = _matrix[1] * _matrix[5] / -_matrix[2] + _matrix[4];
	return new Vector3(_xx, _yy, camera_get_near_plane(proj_mat));
}

function screen_to_ray(view_mat, proj_mat, xx, yy) {
	// credits: TheSnidr / DragoniteSpam / FoxyOfJungle
	var _mx = 2 * (xx / window_get_width() - 0.5) / proj_mat[0];
	var _my = 2 * (yy / window_get_height() - 0.5) / proj_mat[5];
	var _cam_x = - (view_mat[12] * view_mat[0] + view_mat[13] * view_mat[1] + view_mat[14] * view_mat[2]);
	var _cam_y = - (view_mat[12] * view_mat[4] + view_mat[13] * view_mat[5] + view_mat[14] * view_mat[6]);
	var _cam_z = - (view_mat[12] * view_mat[8] + view_mat[13] * view_mat[9] + view_mat[14] * view_mat[10]);
	var _matrix = undefined; // [dx, dy, dz, ox, oy, oz]
	if (proj_mat[15] == 0) {
	// perspective projection
	_matrix = [view_mat[2]  + _mx * view_mat[0] + _my * view_mat[1],
			view_mat[6]  + _mx * view_mat[4] + _my * view_mat[5],
			view_mat[10] + _mx * view_mat[8] + _my * view_mat[9],
			_cam_x,
			_cam_y,
			_cam_z];
	} else {
	// orthographic projection
	_matrix = [view_mat[2],
			view_mat[6],
			view_mat[10],
			_cam_x + _mx * view_mat[0] + _my * view_mat[1],
			_cam_y + _mx * view_mat[4] + _my * view_mat[5],
			_cam_z + _mx * view_mat[8] + _my * view_mat[9]];
	}
	return {
		origin : new Vector3(_matrix[3], _matrix[4], _matrix[5]),
		direction : new Vector3(_matrix[0], _matrix[1], _matrix[2]),
	}
}

function gpu_3d_start(_ztest = true, _zwrite = true, _cullmode = cull_counterclockwise) {
	gpu_set_ztestenable(_ztest)
	gpu_set_zwriteenable(_zwrite)
	gpu_set_cullmode(_cullmode)
}

function gpu_3d_end() {
	gpu_set_ztestenable(false)
	gpu_set_zwriteenable(false)
	gpu_set_cullmode(cull_noculling)
}

///@desc Loads a .obj file from a path and stores it in a struct.
///@arg {string} file_name The name of the file to read from.
///@arg {real} model_matrix A matrix to use for transforming the vertexes and normals.
///@arg {bool} freeze If ths vertex buffer should be freezed or not.
///@arg {bool} cache_model If a parsed buffer should be saved as cache.
///@return {struct} Returns a struct containing the VBO variables and methods.
function load_obj(_file_name, _model_matrix = -1, _freeze = false, _cache_model = false) {	
	static quad_order	= [[1, 4, 2], [2, 4, 3]];
	static def_color	= [1, 1, 1];
	
	static build_vertex = function(_vbo, _fdata, _v, _vc, _vt, _vn, _mtl) {
		var _f		= string_split(_fdata, "/")
		var _flen	= array_length(_f)
		var _fv		= _v[_f[0]-1]
		var _fvc	= _vc[_f[0]-1]
		var _fvt	= _flen > 1 ? (_f[1] != "" ? _vt[_f[1]-1] : [0, 0]) : [0, 0]
		var _fvn	= (_flen > 2 ? _vn[_f[2]-1] : [0, 0, -1]) // default normals facing up		
		var _diff	= _mtl.diffuse
		var _ffc	= (_fvc[0] * _diff[0] * 255) | (_fvc[1] * _diff[1] * 255) << 8 | (_fvc[2] * _diff[2] * 255) << 16					
		vertex_add_point(_vbo, _fv[0], _fv[1], _fv[2], _fvt[0], 1-_fvt[1], _ffc, 1, _fvn[0], _fvn[1], _fvn[2])
	}
	static model = function(_vbo, _name) constructor {
		vbo = _vbo
		name = _name
		frozed = false
		frozed_vbo = -1
		
		///@func freeze()
		static freeze = function() {
			if (frozed) return
			frozed = true
			var _buff = buffer_create_from_vertex_buffer(vbo, buffer_grow, 1)
			frozed_vbo = vertex_create_buffer_from_buffer(_buff, VFORMAT)
			buffer_delete(_buff)
			vertex_freeze(frozed_vbo)
			show_debug_message($"ObjLoader: vertex buffer \"{name}\" successfully freeze.")
		}
		///@func submit([texture])
		static submit = function(_texture = -1) {
			if (vbo == -1) {
				show_debug_message($"ObjLoader error: coudn't submit vertex buffer from file \"{name}\".")
				return
			}
			vertex_submit(frozed ? frozed_vbo : vbo, pr_trianglelist, _texture)
		}
	}
	static material = function(_diffuse, _texture) constructor {
		diffuse = _diffuse
		texture = _texture
	}

	// Get the file path separated from file name
	var _path_arr = string_split(_file_name, "/")
	var _path = ""
	for (var i = 0, n = array_length(_path_arr)-1; i < n; i++) {
		_path += _path_arr[i] + "/"
	}
	
	// Tries to load if from a existing cached buffer
	var _t = get_timer()
	if (_cache_model) {
		var _buffer_name = string_replace(_file_name, ".obj", ".vbo")
		var _buffer = buffer_load(_buffer_name)
		if (_buffer != -1) {
			show_debug_message($"ObjLoader: model loaded from cached file \"{_buffer_name}\"! Load time took {(get_timer()-_t)/1000}ms.")
			var _vbo = vertex_create_buffer_from_buffer(_buffer, VFORMAT)
			buffer_delete(_buffer)
			
			var _model = new model(_vbo, _file_name);
			
			if (_freeze) {
				_model.freeze();
			}
			
			return _model;
		}
	}
	
	var _file = file_text_open_read(_file_name)
	if !(_file) {
		show_debug_message($"ObjLoader error: coudn't load object from file \"{_file_name}\".")
		return new model(-1, _file_name);
	}
	
	var _mtl = -1
	var _current_obj = ""
	var _mtl_list = {}
	var _current_mtl = {diffuse : [1, 1, 1]}
	var _v	= []
	var _vt = []
	var _vn = []
	var _vc = []	
	var _vbo = vertex_create_buffer()
	vertex_begin(_vbo, VFORMAT)
	
	
	while (!file_text_eof(_file)) {
		var _line_str = file_text_readln(_file)
		var _splits = string_split(_line_str, " ") // Split lines into separated elements
		switch (_splits[0]) {
			case "mtllib": { // Load material lib data
				_mtl = file_text_open_read(_path+string_replace(_splits[1], "\n", ""))
				var _temp_mtl_name = ""
				while (!file_text_eof(_mtl)) {
					var _line_mtl = file_text_readln(_mtl)
					var _splits_mtl = string_split(_line_mtl, " ")				

					switch (_splits_mtl[0]) {
						case "newmtl": {
							// Save current material name
							_temp_mtl_name = string_replace(_splits_mtl[1], "\n", "")
							// Add new material to the list
							_mtl_list[$ _temp_mtl_name] = {diffuse : [1, 1, 1]}
						} break;
						case "Kd": {
							// Get material diffuse color
							var _gamma_fac = 1/2.2
							_mtl_list[$ _temp_mtl_name].diffuse = [
								power(real(_splits_mtl[1]), _gamma_fac), 
								power(real(_splits_mtl[2]), _gamma_fac), 
								power(real(_splits_mtl[3]), _gamma_fac)
							]
						} break;
						case "map_Kd": {
							// Get material texture
						} break;
					}
				}
				file_text_close(_mtl)
			} break;
			
			case "o": { // Object data
				// Resets material for each object
				_current_obj = string_replace(string_concat_ext(_splits, 1), "\n", "")
				_current_mtl = {diffuse : [1, 1, 1]}
			} break;
			
			case "v": { // Vertex position
				var _x = _splits[1]
				var _y = _splits[2]
				var _z = _splits[3]
				var _vertexes = [_x, _y, _z]
				
				if (is_array(_model_matrix)) {
					_vertexes = matrix_transform_vertex(_model_matrix, _x, _y, _z)
				}
				
				array_push(_v, _vertexes)
				
				// If it has vertex color, multiply it by diffuse color
				// If not, multiply default color (white) by diffuse color
				if (array_length(_splits) > 4) {
					array_push(_vc, [real(_splits[4]), real(_splits[5]), real(_splits[6])])
				} else {
					array_push(_vc, [def_color[0], def_color[1], def_color[2]])
				}
			} break;
			
			case "vt": { // Vertex texcoord
				array_push(_vt, [_splits[1], _splits[2]])
			} break;

			case "vn": { // Vertex normal				
				var _x = _splits[1]
				var _y = _splits[2]
				var _z = _splits[3]
				var _normal = [_x, _y, _z]
				
				if (is_array(_model_matrix)) {
					_normal = matrix_transform_vertex(_model_matrix, _x, _y, _z)
				}
				
				array_push(_vn, _normal)
			} break;
			
			case "usemtl": { // Material data
				var _mtl_name = string_replace(_splits[1], "\n", "")
				_current_mtl = _mtl_list[$ _mtl_name]

			} break;
			
			case "f": { // Build face				
				if (array_length(_splits) > 4) { // Quad
					for (var j = 0; j < 2; j++) {						
						for (var i = 0; i < 3; i++) {
							var _fdata	= _splits[quad_order[j][i]]
							build_vertex(_vbo, _fdata, _v, _vc, _vt, _vn,_current_mtl)
						}
					}				
				} else { // Tri
					for (var i = 2; i >= 0; i--) {
						var _fdata	= _splits[i+1]
						build_vertex(_vbo, _fdata, _v, _vc, _vt, _vn, _current_mtl)
					}
				}
			} break;
		}
	}
	
	file_text_close(_file)
	vertex_end(_vbo)
	var _model = new model(_vbo, _file_name);
	
	// Cache the model if so
	if (_cache_model) {
		var _buffer = buffer_create_from_vertex_buffer(_vbo, buffer_grow, 1)
		buffer_save(_buffer, _buffer_name)
		buffer_delete(_buffer)
	}
	
	// Freeze the model if so
	if (_freeze) {
		_model.freeze()
	}
	
	show_debug_message($"ObjLoader: model \"{_file_name}\" successfully loaded! Load time took {(get_timer()-_t)/1000}ms.")
	return _model;
}

//TODO: add spritestack_create() from an old project

//--------- since there is now a .obj load function there's no need to manually create complex primitives so anywaw

/*

#region Primitives

function vertex_add_point(_vbo, _x, _y, _z, _nx, _ny, _nz, _col, _a, _u, _v) {
	vertex_position_3d(_vbo, _x, _y, _z)
	vertex_normal(_vbo, _nx, _ny, _nz)
	vertex_color(_vbo, _col, _a)
	vertex_texcoord(_vbo, _u, _v)
}

function vertex_add_face(_vbo, _x, _y, _z, _xrot = 0, _yrot = 0, _zrot = 0, _xscale = 1, _yscale = 1, _zscale = 1, _c = c_white, _a = 1) {
	// Default coordinates
	var _v1 = [-1, -1, 0]
	var _v2 = [1, -1, 0]
	var _v3 = [-1, 1, 0]
	var _v4 = [1, 1, 0]
	
	// Model matrix
	var _mat = matrix_build_srt(_x, _y, _z,		_xrot, _yrot, _zrot,	_xscale, _yscale, _zscale)	
	
	// Transformed coordinates
	_v1 = matrix_transform_vertex_array(_mat, _v1)
	_v2 = matrix_transform_vertex_array(_mat, _v2)
	_v3 = matrix_transform_vertex_array(_mat, _v3)
	_v4 = matrix_transform_vertex_array(_mat, _v4)

	// Build mesh
	vertex_add_point(_vbo,	_v1[0], _v1[1], _v1[2],		0, 0, -1,		_c, _a,		0, 0)
	vertex_add_point(_vbo,	_v2[0], _v2[1], _v2[2],		0, 0, -1,		_c, _a,		1, 0)
	vertex_add_point(_vbo,	_v3[0], _v3[1], _v3[2],		0, 0, -1,		_c, _a,		0, 1)																			
																	 
	vertex_add_point(_vbo,	_v3[0], _v3[1], _v3[2],		0, 0, -1,		_c, _a,		0, 1)
	vertex_add_point(_vbo,	_v2[0], _v2[1], _v2[2],		0, 0, -1,		_c, _a,		1, 0)
	vertex_add_point(_vbo,	_v4[0], _v4[1], _v4[2],		0, 0, -1,		_c, _a,		1, 1)
}

function vertex_add_circle(_vbo, _x, _y, _z, _xrot = 0, _yrot = 0, _zrot = 0, _xscale = 1, _yscale = 1, _zscale = 1, _sides = 32, _c = c_white, _a = 1) {		
	
	// Center
    var _v1 = [0, 0, 0];	
	
	// UVs
	var _u1 = [0.5, 0.5];
	
	// Model matrix
	var _mat = matrix_build_srt(_x, _y, _z,		_xrot, _yrot, _zrot,	_xscale, _yscale, _zscale)	
	
	// Transformed coordinates
	_v1 = matrix_transform_vertex_array(_mat, _v1)	
	
	var _sides_clamped = clamp(_sides, 3, 256)
	var _step = 2 * pi / _sides_clamped;
    for (var i = 0; i < _sides_clamped; i++) {
        var _ang = i * _step;
        var _ang_next = (_ang + _step) % (2 * pi);		
		
		var _v2 = [cos(_ang), sin(_ang), 0];
        var _v3 = [cos(_ang_next), sin(_ang_next), 0];
		
		var _u2 = [_v2[0]*0.5+0.5, _v2[1]*0.5+0.5];
        var _u3 = [_v3[0]*0.5+0.5, _v3[1]*0.5+0.5];
		
		_v2 = matrix_transform_vertex_array(_mat, _v2)
		_v3 = matrix_transform_vertex_array(_mat, _v3)
		
		vertex_add_point(_vbo,	_v1[0], _v1[1], _v1[2],		0, 0, -1,		_c, _a,		_u1[0], _u1[1])
		vertex_add_point(_vbo,	_v2[0], _v2[1], _v2[2],		0, 0, -1,		_c, _a,		_u2[0], _u2[1])
		vertex_add_point(_vbo,	_v3[0], _v3[1], _v3[2],		0, 0, -1,		_c, _a,		_u3[0], _u3[1])
	}
}

function vertex_add_cube(_vbo, _x, _y, _z, _xrot = 0, _yrot = 0, _zrot = 0, _xscale = 1, _yscale = 1, _zscale = 1, _c = c_white, _a = 1) {
	// Default coordinates
	var _v1 = [-1,	-1,	-1]
	var _v2 = [1,	-1,	-1]
	var _v3 = [-1,	1,	-1]
	var _v4 = [1,	1,	-1]
	var _v5 = [-1,	-1,	1]
	var _v6 = [1,	-1,	1]
	var _v7 = [-1,	1,	1]
	var _v8 = [1,	1,	1]
	
	// Model matrix
	var _mat = matrix_build_srt(_x, _y, _z, _xrot, _yrot, _zrot, _xscale, _yscale, _zscale)
	
	// Transformed coordinates
	_v1 = matrix_transform_vertex_array(_mat, _v1)
	_v2 = matrix_transform_vertex_array(_mat, _v2)
	_v3 = matrix_transform_vertex_array(_mat, _v3)
	_v4 = matrix_transform_vertex_array(_mat, _v4)
	_v5 = matrix_transform_vertex_array(_mat, _v5)
	_v6 = matrix_transform_vertex_array(_mat, _v6)
	_v7 = matrix_transform_vertex_array(_mat, _v7)
	_v8 = matrix_transform_vertex_array(_mat, _v8)
	
	
	//						position					normal			color		uv	
	// right				
	vertex_add_point(_vbo,	_v4[0], _v4[1], _v4[2],		1, 0, 0,		_c, _a,		0, 0)
	vertex_add_point(_vbo,	_v2[0], _v2[1], _v2[2],		1, 0, 0,		_c, _a,		1, 0)
	vertex_add_point(_vbo,	_v8[0], _v8[1], _v8[2],		1, 0, 0,		_c, _a,		0, 1)
																 
	vertex_add_point(_vbo,	_v8[0], _v8[1], _v8[2],		1, 0, 0,		_c, _a,		0, 1)
	vertex_add_point(_vbo,	_v2[0], _v2[1], _v2[2],		1, 0, 0,		_c, _a,		1, 0)
	vertex_add_point(_vbo,	_v6[0], _v6[1], _v6[2],		1, 0, 0,		_c, _a,		1, 1)
																 
	// left														 
	vertex_add_point(_vbo,	_v1[0], _v1[1], _v1[2],		-1, 0, 0,		_c, _a,		0, 0)
	vertex_add_point(_vbo,	_v3[0], _v3[1], _v3[2],		-1, 0, 0,		_c, _a,		1, 0)
	vertex_add_point(_vbo,	_v5[0], _v5[1], _v5[2],		-1, 0, 0,		_c, _a,		0, 1)
														 
	vertex_add_point(_vbo,	_v5[0], _v5[1], _v5[2],		-1, 0, 0,		_c, _a,		0, 1)
	vertex_add_point(_vbo,	_v3[0], _v3[1], _v3[2],		-1, 0, 0,		_c, _a,		1, 0)
	vertex_add_point(_vbo,	_v7[0], _v7[1], _v7[2],		-1, 0, 0,		_c, _a,		1, 1)
														 
	// back														 
	vertex_add_point(_vbo,	_v2[0], _v2[1], _v2[2],		0, -1, 0,		_c, _a,		0, 0)
	vertex_add_point(_vbo,	_v1[0], _v1[1], _v1[2],		0, -1, 0,		_c, _a,		1, 0)
	vertex_add_point(_vbo,	_v6[0], _v6[1], _v6[2],		0, -1, 0,		_c, _a,		0, 1)
														 
	vertex_add_point(_vbo,	_v6[0], _v6[1], _v6[2],		0, -1, 0,		_c, _a,		0, 1)
	vertex_add_point(_vbo,	_v1[0], _v1[1], _v1[2],		0, -1, 0,		_c, _a,		1, 0)
	vertex_add_point(_vbo,	_v5[0], _v5[1], _v5[2],		0, -1, 0,		_c, _a,		1, 1)
														 
	// front													 
	vertex_add_point(_vbo,	_v3[0], _v3[1], _v3[2],		0, 1, 0,		_c, _a,		0, 0)
	vertex_add_point(_vbo,	_v4[0], _v4[1], _v4[2],		0, 1, 0,		_c, _a,		1, 0)
	vertex_add_point(_vbo,	_v7[0], _v7[1], _v7[2],		0, 1, 0,		_c, _a,		0, 1)
														 
	vertex_add_point(_vbo,	_v7[0], _v7[1], _v7[2],		0, 1, 0,		_c, _a,		0, 1)
	vertex_add_point(_vbo,	_v4[0], _v4[1], _v4[2],		0, 1, 0,		_c, _a,		1, 0)
	vertex_add_point(_vbo,	_v8[0], _v8[1], _v8[2],		0, 1, 0,		_c, _a,		1, 1)
																 
	// top														 
	vertex_add_point(_vbo,	_v1[0], _v1[1], _v1[2],		0, 0, -1,		_c, _a,		0, 0)
	vertex_add_point(_vbo,	_v2[0], _v2[1], _v2[2],		0, 0, -1,		_c, _a,		1, 0)
	vertex_add_point(_vbo,	_v3[0], _v3[1], _v3[2],		0, 0, -1,		_c, _a,		0, 1)																			
																 
	vertex_add_point(_vbo,	_v3[0], _v3[1], _v3[2],		0, 0, -1,		_c, _a,		0, 1)
	vertex_add_point(_vbo,	_v2[0], _v2[1], _v2[2],		0, 0, -1,		_c, _a,		1, 0)
	vertex_add_point(_vbo,	_v4[0], _v4[1], _v4[2],		0, 0, -1,		_c, _a,		1, 1)
																 
	// bot														 
	vertex_add_point(_vbo,	_v7[0], _v7[1], _v7[2],		0, 0, 1,		_c, _a,		0, 0)
	vertex_add_point(_vbo,	_v8[0], _v8[1], _v8[2],		0, 0, 1,		_c, _a,		1, 0)
	vertex_add_point(_vbo,	_v5[0], _v5[1], _v5[2],		0, 0, 1,		_c, _a,		0, 1)																			
																 
	vertex_add_point(_vbo,	_v5[0], _v5[1], _v5[2],		0, 0, 1,		_c, _a,		0, 1)
	vertex_add_point(_vbo,	_v8[0], _v8[1], _v8[2],		0, 0, 1,		_c, _a,		1, 0)
	vertex_add_point(_vbo,	_v6[0], _v6[1], _v6[2],		0, 0, 1,		_c, _a,		1, 1)
}

function vertex_add_sphere(_vbo, _x, _y, _z, _xrot = 0, _yrot = 0, _zrot = 0, _xscale = 1, _yscale = 1, _zscale = 1, _hverts = 32, _vverts = 16, _hrep = 1, _vrep = 1, _c = c_white, _a = 1) {
	
	// Model matrix
	var _mat = matrix_build_srt(_x, _y, _z,		_xrot, _yrot, _zrot,	_xscale, _yscale, _zscale)		
	
	for (var _xx = 0; _xx < _hverts; _xx++) {
		var _xa1 = _xx / _hverts * 2 * pi;
		var _xa2 = (_xx+1) / _hverts * 2 * pi;
		var _xc1 = cos(_xa1)
		var _xs1 = sin(_xa1)
		var _xc2 = cos(_xa2)
		var _xs2 = sin(_xa2)	
		
		for (var _yy = 0; _yy < _vverts; _yy++) {
			var _ya1 = _yy / _vverts * pi;
			var _ya2 = (_yy+1) / _vverts * pi;
			var _yc1 = cos(_ya1);
			var _ys1 = sin(_ya1);
			var _yc2 = cos(_ya2);
			var _ys2 = sin(_ya2);
			
			// Default values
			var _v1 = [_xc2 * _ys2, _xs2 * _ys2, _yc2]
			var _v2 = [_xc1 * _ys2, _xs1 * _ys2, _yc2]
			var _v3 = [_xc2 * _ys1, _xs2 * _ys1, _yc1]
			var _v4 = [_xc1 * _ys1, _xs1 * _ys1, _yc1]			
			
			// Get smooth normals
			var _n1 = new Vector3(_v1[0], _v1[1], _v1[2]).Normalize().ToArray()
			var _n2 = new Vector3(_v2[0], _v2[1], _v2[2]).Normalize().ToArray()
			var _n3 = new Vector3(_v3[0], _v3[1], _v3[2]).Normalize().ToArray()
			var _n4 = new Vector3(_v4[0], _v4[1], _v4[2]).Normalize().ToArray()
			
			// Transformed coordinates
			_v1 = matrix_transform_vertex_array(_mat, _v1)
			_v2 = matrix_transform_vertex_array(_mat, _v2)
			_v3 = matrix_transform_vertex_array(_mat, _v3)
			_v4 = matrix_transform_vertex_array(_mat, _v4)
			
			
			// Build mesh
			vertex_add_point(_vbo, _v1[0], _v1[1], _v1[2],		_n1[0], _n1[1], _n1[2],		_c, _a,		(_xx+1) / _hverts * _hrep, (_yy+1) / _vverts * _vrep)
			vertex_add_point(_vbo, _v2[0], _v2[1], _v2[2],		_n2[0], _n2[1], _n2[2],		_c, _a,		_xx / _hverts * _hrep, (_yy+1) / _vverts * _vrep)
			vertex_add_point(_vbo, _v3[0], _v3[1], _v3[2],		_n3[0], _n3[1], _n3[2],		_c, _a,		(_xx+1) / _hverts * _hrep, _yy / _vverts * _vrep)
								   													
			vertex_add_point(_vbo, _v3[0], _v3[1], _v3[2],		_n3[0], _n3[1], _n3[2],		_c, _a,		(_xx+1) / _hverts * _hrep, _yy / _vverts * _vrep)
			vertex_add_point(_vbo, _v2[0], _v2[1], _v2[2],		_n2[0], _n2[1], _n2[2],		_c, _a,		_xx / _hverts * _hrep, (_yy+1) / _vverts * _vrep)
			vertex_add_point(_vbo, _v4[0], _v4[1], _v4[2],		_n4[0], _n4[1], _n4[2],		_c, _a,		_xx / _hverts * _hrep, _yy / _vverts * _vrep)
		}
	}	
}

function vertex_add_cone(_vbo, _x, _y, _z, _xrot = 0, _yrot = 0, _zrot = 0, _xscale = 1, _yscale = 1, _zscale = 1, _sides = 32, _closed = true, _c = c_white, _a = 1) {		
	
	// Base
    var _v1 = [0, 0, -1];
	
	// Tip
	var _v4 = [0, 0, 1]
	
	// UVs
	var _u1 = [0.5, 0.5];
	
	// Model matrix
	var _mat = matrix_build_srt(_x, _y, _z,		_xrot, _yrot, _zrot,	_xscale, _yscale, _zscale)	
	
	// Transformed coordinates
	_v1 = matrix_transform_vertex_array(_mat, _v1)
	_v4 = matrix_transform_vertex_array(_mat, _v4)
	
	var _sides_clamped = clamp(_sides, 3, 256)
	var _step = 2 * pi / _sides_clamped;
    for (var i = 0; i < _sides_clamped; i++) {
        var _ang = i * _step;
        var _ang_next = (_ang + _step) % (2 * pi);		
		
		var _v2 = [cos(_ang), sin(_ang), -1];
        var _v3 = [cos(_ang_next), sin(_ang_next), -1];
		
		var _u2 = [_v2[0]*0.5+0.5, _v2[1]*0.5+0.5];
		var _u3 = [_v3[0]*0.5+0.5, _v3[1]*0.5+0.5];
		
		_v2 = matrix_transform_vertex_array(_mat, _v2)
		_v3 = matrix_transform_vertex_array(_mat, _v3)
		
		// Walls
		vertex_add_point(_vbo,	_v4[0], _v4[1], _v4[2],		0, 0, -1,		_c, _a,		_u1[0], _u1[1])
		vertex_add_point(_vbo,	_v3[0], _v3[1], _v3[2],		0, 0, -1,		_c, _a,		_u3[0], _u3[1])
		vertex_add_point(_vbo,	_v2[0], _v2[1], _v2[2],		0, 0, -1,		_c, _a,		_u2[0], _u2[1])
		
		// Base	
		if (_closed) {
			vertex_add_point(_vbo,	_v1[0], _v1[1], _v1[2],		0, 0, -1,		_c, _a,		_u1[0], _u1[1])
			vertex_add_point(_vbo,	_v2[0], _v2[1], _v2[2],		0, 0, -1,		_c, _a,		_u2[0], _u2[1])
			vertex_add_point(_vbo,	_v3[0], _v3[1], _v3[2],		0, 0, -1,		_c, _a,		_u3[0], _u3[1])
		}	
	}
}

function vertex_add_cylinder(_vbo, _x, _y, _z, _xrot = 0, _yrot = 0, _zrot = 0, _xscale = 1, _yscale = 1, _zscale = 1, _sides = 32, _toprad = 1, _botrad = 1, _hrep = 1, _c = c_white, _a = 1) {		
	
	// UVs
	var _uc1 = [0.5, 0.5];
	
	// Model matrix
	var _mat = matrix_build_srt(_x, _y, _z,		_xrot, _yrot, _zrot,	_xscale, _yscale, _zscale)		
	
	var _sides_clamped = clamp(_sides, 3, 256)
	var _step = 2 * pi / _sides_clamped;
    for (var i = 0; i < _sides_clamped; i++) {
        var _ang = i * _step;
        var _ang_next = (_ang + _step) % (2 * pi);		
		
		// Default coordinates
		var _vb = [0, 0, -1];
		var _vt = [0, 0, 1]
		var _v1 = [cos(_ang), sin(_ang), _vt[2]];
        var _v2 = [cos(_ang_next), sin(_ang_next), _vt[2]];
		var _v3 = [cos(_ang), sin(_ang), _vb[2]];
        var _v4 = [cos(_ang_next), sin(_ang_next), _vb[2]];
		
		// UVs for faces
		var _uc2 = [_v3[0]*0.5+0.5, _v3[1]*0.5+0.5];
		var _uc3 = [_v4[0]*0.5+0.5, _v4[1]*0.5+0.5];
		
		// Apply face scale
		_v1[0] *= _botrad
		_v1[1] *= _botrad
		_v2[0] *= _botrad
		_v2[1] *= _botrad
		_v3[0] *= _toprad
		_v3[1] *= _toprad
		_v4[0] *= _toprad
		_v4[1] *= _toprad		
	
		
		// UVs for sides
		var _u1 = [_ang / (2 * pi), 0];
		var _u2 = [(_ang + _step) / (2 * pi), 0];
		var _u3 = [_ang / (2 * pi), 1];;
		var _u4 = [(_ang + _step) / (2 * pi), 1];
		
		
		// Transformed coordinates
		_vb = matrix_transform_vertex_array(_mat, _vb)
		_vt = matrix_transform_vertex_array(_mat, _vt)
		_v1 = matrix_transform_vertex_array(_mat, _v1)
		_v2 = matrix_transform_vertex_array(_mat, _v2)
		_v3 = matrix_transform_vertex_array(_mat, _v3)
		_v4 = matrix_transform_vertex_array(_mat, _v4)
		
		// Top face
		if (_toprad > 0) {
			vertex_add_point(_vbo,	_vt[0], _vt[1], _vt[2],		0, 0, -1,		_c, _a,		_uc1[0], _uc1[1])
			vertex_add_point(_vbo,	_v2[0], _v2[1], _v2[2],		0, 0, -1,		_c, _a,		_uc3[0], _uc3[1])
			vertex_add_point(_vbo,	_v1[0], _v1[1], _v1[2],		0, 0, -1,		_c, _a,		_uc2[0], _uc2[1])
		}
		
		// Bottom face
		if (_botrad > 0) {
			vertex_add_point(_vbo,	_vb[0], _vb[1], _vb[2],		0, 0, -1,		_c, _a,		_uc1[0], _uc1[1])
			vertex_add_point(_vbo,	_v3[0], _v3[1], _v3[2],		0, 0, -1,		_c, _a,		_uc2[0], _uc2[1])
			vertex_add_point(_vbo,	_v4[0], _v4[1], _v4[2],		0, 0, -1,		_c, _a,		_uc3[0], _uc3[1])
		}
		
		// Walls
		vertex_add_point(_vbo,	_v1[0], _v1[1], _v1[2],		0, 0, -1,		_c, _a,		_u1[0], _u1[1])
		vertex_add_point(_vbo,	_v2[0], _v2[1], _v2[2],		0, 0, -1,		_c, _a,		_u2[0], _u2[1])
		vertex_add_point(_vbo,	_v3[0], _v3[1], _v3[2],		0, 0, -1,		_c, _a,		_u3[0], _u3[1])		
		vertex_add_point(_vbo,	_v3[0], _v3[1], _v3[2],		0, 0, -1,		_c, _a,		_u3[0], _u3[1])
		vertex_add_point(_vbo,	_v2[0], _v2[1], _v2[2],		0, 0, -1,		_c, _a,		_u2[0], _u2[1])
		vertex_add_point(_vbo,	_v4[0], _v4[1], _v4[2],		0, 0, -1,		_c, _a,		_u4[0], _u4[1])
	}
}

function vertex_add_capsule(_vbo, _x, _y, _z, _xrot = 0, _yrot = 0, _zrot = 0, _xscale = 1, _yscale = 1, _zscale = 1, _hverts = 32, _vverts = 16, _hrep = 1, _vrep = 1, _c = c_white, _a = 1) {
	
	// dont ask why.
	var _half_vrep = _vrep/2
	var _half_verts = _vverts/2
	
	// Model matrix
	var _mat = matrix_build_srt(_x, _y, _z,		_xrot, _yrot, _zrot,	_xscale, _yscale, _zscale)		
	
	for (var _xx = 0; _xx < _hverts; _xx++) {
		var _xa1 = _xx / _hverts * 2 * pi;
		var _xa2 = (_xx+1) / _hverts * 2 * pi;
		var _xc1 = cos(_xa1)
		var _xs1 = sin(_xa1)
		var _xc2 = cos(_xa2)
		var _xs2 = sin(_xa2)	
		
		var _height = 1;
		
		// Walls
		var _v1 = [_xc1, _xs1, _height]
		var _v2 = [_xc2, _xs2, _height]
		var _v3 = [_xc1, _xs1, -_height]
		var _v4 = [_xc2, _xs2, -_height]
		
		// Get smooth normals
		var _n1 = new Vector3(_v1[0], _v1[1], _v1[2]).Normalize().ToArray()
		var _n2 = new Vector3(_v2[0], _v2[1], _v2[2]).Normalize().ToArray()
		var _n3 = new Vector3(_v3[0], _v3[1], _v3[2]).Normalize().ToArray()
		var _n4 = new Vector3(_v4[0], _v4[1], _v4[2]).Normalize().ToArray()

		// UVs for sides
		var _u1 = [_xa1 / (2*pi), 0];
		var _u2 = [_xa2 / (2*pi), 0];
		var _u3 = [_xa1 / (2*pi), 1];
		var _u4 = [_xa2 / (2*pi), 1];
		
		_v1 = matrix_transform_vertex_array(_mat, _v1)
		_v2 = matrix_transform_vertex_array(_mat, _v2)
		_v3 = matrix_transform_vertex_array(_mat, _v3)
		_v4 = matrix_transform_vertex_array(_mat, _v4)
		
		// Side faces
		vertex_add_point(_vbo, _v1[0], _v1[1], _v1[2],		_n1[0], _n1[1], _n1[2],		_c, _a,		_u1[0], _u1[1])
		vertex_add_point(_vbo, _v2[0], _v2[1], _v2[2],		_n2[0], _n2[1], _n2[2],		_c, _a,		_u2[0], _u2[1])
		vertex_add_point(_vbo, _v3[0], _v3[1], _v3[2],		_n3[0], _n3[1], _n3[2],		_c, _a,		_u3[0], _u3[1])						   															
		vertex_add_point(_vbo, _v3[0], _v3[1], _v3[2],		_n3[0], _n3[1], _n3[2],		_c, _a,		_u3[0], _u3[1])
		vertex_add_point(_vbo, _v2[0], _v2[1], _v2[2],		_n2[0], _n2[1], _n2[2],		_c, _a,		_u2[0], _u2[1])
		vertex_add_point(_vbo, _v4[0], _v4[1], _v4[2],		_n4[0], _n4[1], _n4[2],		_c, _a,		_u4[0], _u4[1])
		
		for (var _yy = 0; _yy < _half_verts; _yy++) {
			var _ya1 = _yy / _half_verts * pi / 2;
			var _ya2 = (_yy+1) / _half_verts * pi / 2;
			var _yc1 = cos(_ya1);
			var _ys1 = sin(_ya1);
			var _yc2 = cos(_ya2);
			var _ys2 = sin(_ya2);
			
			// Default values
			var _v1 = [_xc2 * _ys2, _xs2 * _ys2, -_yc2-_height]
			var _v2 = [_xc1 * _ys2, _xs1 * _ys2, -_yc2-_height]
			var _v3 = [_xc2 * _ys1, _xs2 * _ys1, -_yc1-_height]
			var _v4 = [_xc1 * _ys1, _xs1 * _ys1, -_yc1-_height]
			
			var _v5 = [_xc2 * _ys2, _xs2 * _ys2, _yc2+_height]
			var _v6 = [_xc1 * _ys2, _xs1 * _ys2, _yc2+_height]
			var _v7 = [_xc2 * _ys1, _xs2 * _ys1, _yc1+_height]
			var _v8 = [_xc1 * _ys1, _xs1 * _ys1, _yc1+_height]
			
			// Get flat normals	- FIX THIS!!!
			var _nv1 = new Vector3(_v1[0], _v1[1], _v1[2])
			var _nv2 = new Vector3(_v2[0], _v2[1], _v2[2])
			var _nv3 = new Vector3(_v3[0], _v3[1], _v3[2])
			var _nv4 = new Vector3(_v4[0], _v4[1], _v4[2])
			
			// Tri 1
			var _e1 = _nv4.Subtract(_nv3)
			var _e2 = _nv1.Subtract(_nv3)
			var _n1 = _e1.Cross(_e2).Normalize().Negate().ToArray();
			
			// Tri 2
			var _e1 = _nv2.Subtract(_nv1)
			var _e2 = _nv4.Subtract(_nv1)
			var _n2 = _e1.Cross(_e2).Normalize().Negate().ToArray();			

	
			// Transformed coordinates
			_v1 = matrix_transform_vertex_array(_mat, _v1)
			_v2 = matrix_transform_vertex_array(_mat, _v2)
			_v3 = matrix_transform_vertex_array(_mat, _v3)
			_v4 = matrix_transform_vertex_array(_mat, _v4)
			
			_v5 = matrix_transform_vertex_array(_mat, _v5)
			_v6 = matrix_transform_vertex_array(_mat, _v6)
			_v7 = matrix_transform_vertex_array(_mat, _v7)
			_v8 = matrix_transform_vertex_array(_mat, _v8)
			
			
			// Top hemisphere - still mirrored but who cares
			vertex_add_point(_vbo, _v3[0], _v3[1], _v3[2],			_n1[0], _n1[1], _n1[2],		_c, _a,		(_xx+1) / _hverts * _hrep, _yy / _half_verts * _half_vrep)
			vertex_add_point(_vbo, _v4[0], _v4[1], _v4[2],			_n1[0], _n1[1], _n1[2],		_c, _a,		_xx / _hverts * _hrep, _yy / _half_verts * _half_vrep)
			vertex_add_point(_vbo, _v1[0], _v1[1], _v1[2],			_n1[0], _n1[1], _n1[2],		_c, _a,		(_xx+1) / _hverts * _hrep, (_yy+1) / _half_verts * _half_vrep)
																									
			vertex_add_point(_vbo, _v1[0], _v1[1], _v1[2],			_n2[0], _n2[1], _n2[2],		_c, _a,		(_xx+1) / _hverts * _hrep, (_yy+1) / _half_verts * _half_vrep)
			vertex_add_point(_vbo, _v4[0], _v4[1], _v4[2],			_n2[0], _n2[1], _n2[2],		_c, _a,		_xx / _hverts * _hrep, _yy / _half_verts * _half_vrep)
			vertex_add_point(_vbo, _v2[0], _v2[1], _v2[2],			_n2[0], _n2[1], _n2[2],		_c, _a,		_xx / _hverts * _hrep, (_yy+1) / _half_verts * _half_vrep)
																		 		 
			// Bot hemisphere											 		 
			vertex_add_point(_vbo, _v5[0], _v5[1], _v5[2],		_n2[0], _n2[1], _n2[2],		_c, _a,		(_xx+1) / _hverts * _hrep, (_yy+1) / _half_verts * _half_vrep)
			vertex_add_point(_vbo, _v6[0], _v6[1], _v6[2],		_n2[0], _n2[1], _n2[2],		_c, _a,		_xx / _hverts * _hrep, (_yy+1) / _half_verts * _half_vrep)
			vertex_add_point(_vbo, _v7[0], _v7[1], _v7[2],		_n2[0], _n2[1], _n2[2],		_c, _a,		(_xx+1) / _hverts * _hrep, _yy / _half_verts * _half_vrep)
			  																		
			vertex_add_point(_vbo, _v7[0], _v7[1], _v7[2],		_n2[0], _n2[1], _n2[2],		_c, _a,		(_xx+1) / _hverts * _hrep, _yy / _half_verts * _half_vrep)
			vertex_add_point(_vbo, _v6[0], _v6[1], _v6[2],		_n2[0], _n2[1], _n2[2],		_c, _a,		_xx / _hverts * _hrep, (_yy+1) / _half_verts * _half_vrep)
			vertex_add_point(_vbo, _v8[0], _v8[1], _v8[2],		_n2[0], _n2[1], _n2[2],		_c, _a,		_xx / _hverts * _hrep, _yy / _half_verts * _half_vrep)
		}
	}
}

function vertex_add_torus() {
	
}

#endregion

function model_submit(_vbo, _albedo = -1, _subimg = 0, _normal = -1, _specular = -1, _prim = pr_trianglelist) {
	var _tex = -1
	static u_uvs_albedo = shader_get_uniform(shd_gbuff_main, "u_uvs_albedo")
	static u_uvs_normal = shader_get_uniform(shd_gbuff_main, "u_uvs_normal")
	static u_uvs_specular = shader_get_uniform(shd_gbuff_main, "u_uvs_specular")
	static u_tex_data = shader_get_uniform(shd_gbuff_main, "u_texdata")
	
	static blank = [0, 0, 0, 0];
	
	var _has_normal = false
	var _has_specular = false
	
	if (sprite_exists(_albedo)) {
		var _uvs = sprite_get_uvs(_albedo, _subimg)
		_tex = sprite_get_texture(_albedo, _subimg)
		shader_set_uniform_f_array(u_uvs_albedo, _uvs);
	} else {
		shader_set_uniform_f_array(u_uvs_albedo, blank);
		_tex = -1 // wrong??
	}
	
	if (sprite_exists(_normal)) {
		var _uvs = sprite_get_uvs(_normal, _subimg)
		_tex = sprite_get_texture(_normal, _subimg)
		shader_set_uniform_f_array(u_uvs_normal, _uvs);
		_has_normal = true
	} else {
		shader_set_uniform_f_array(u_uvs_normal, blank);
	}
	
	if (sprite_exists(_specular)) {
		var _uvs = sprite_get_uvs(_specular, _subimg)
		_tex = sprite_get_texture(_specular, _subimg)
		shader_set_uniform_f_array(u_uvs_specular, _uvs);
		_has_specular = true
	} else {
		shader_set_uniform_f_array(u_uvs_specular, blank);
	}
	
	shader_set_uniform_f(u_tex_data, _has_normal, _has_specular)
	vertex_submit(_vbo, _prim, _tex)
}

function model_set_material(_material) {
	shader_set_uniform_f(shader_get_uniform(shd_gbuff_main, "u_material_type"), _material);
}



function model_calculate_normals(_vbo) {
	var _buffer = buffer_create_from_vertex_buffer(_vbo, buffer_fixed, 1)
	vertex_delete_buffer(_vbo)
	
	for (var i = 0; i < buffer_get_size(_buffer); i += 36 * 3) {
		var _x1 = buffer_peek(_buffer, i + 00, buffer_f32)
		var _y1 = buffer_peek(_buffer, i + 04, buffer_f32)
		var _z1 = buffer_peek(_buffer, i + 08, buffer_f32)
		
		var _x2 = buffer_peek(_buffer, i + 36, buffer_f32)
		var _y2 = buffer_peek(_buffer, i + 40, buffer_f32)
		var _z2 = buffer_peek(_buffer, i + 44, buffer_f32)
		
		var _x3 = buffer_peek(_buffer, i + 72, buffer_f32)
		var _y3 = buffer_peek(_buffer, i + 76, buffer_f32)
		var _z3 = buffer_peek(_buffer, i + 80, buffer_f32)
		
		var _v1 = new Vector3(_x1, _y1, _z1)
		var _v2 = new Vector3(_x2, _y2, _z2)
		var _v3 = new Vector3(_x3, _y3, _z3)
		
		var _e1 = _v2.Subtract(_v1)
		var _e2 = _v3.Subtract(_v1)
		
		var _norm = _e1.Cross(_e2).Normalize().Negate();
		
		buffer_poke(_buffer, i + 12, buffer_f32, _norm.x)
		buffer_poke(_buffer, i + 16, buffer_f32, _norm.y)
		buffer_poke(_buffer, i + 20, buffer_f32, _norm.z)
			   
		buffer_poke(_buffer, i + 48, buffer_f32, _norm.x)
		buffer_poke(_buffer, i + 52, buffer_f32, _norm.y)
		buffer_poke(_buffer, i + 56, buffer_f32, _norm.z)
			   
		buffer_poke(_buffer, i + 84, buffer_f32, _norm.x)
		buffer_poke(_buffer, i + 88, buffer_f32, _norm.y)
		buffer_poke(_buffer, i + 92, buffer_f32, _norm.z)
	}
	
	var _vbo_calculated = vertex_create_buffer_from_buffer(_buffer, VFORMAT)	
	buffer_delete(_buffer)
	
	return _vbo_calculated;
}

function model_calculate_normals_smooth(_vbo, _threshold = 70) {
	var _buffer = buffer_create_from_vertex_buffer(_vbo, buffer_fixed, 1)
	vertex_delete_buffer(_vbo)	
	var _normal_cache = {};	
	
	for (var i = 0; i < buffer_get_size(_buffer); i += 36 * 3) {
		// Read vertex position
		var _x1 = buffer_peek(_buffer, i + 00, buffer_f32)
		var _y1 = buffer_peek(_buffer, i + 04, buffer_f32)
		var _z1 = buffer_peek(_buffer, i + 08, buffer_f32)
		
		var _x2 = buffer_peek(_buffer, i + 36, buffer_f32)
		var _y2 = buffer_peek(_buffer, i + 40, buffer_f32)
		var _z2 = buffer_peek(_buffer, i + 44, buffer_f32)
		
		var _x3 = buffer_peek(_buffer, i + 72, buffer_f32)
		var _y3 = buffer_peek(_buffer, i + 76, buffer_f32)
		var _z3 = buffer_peek(_buffer, i + 80, buffer_f32)
		
		var _v1 = new Vector3(_x1, _y1, _z1)
		var _v2 = new Vector3(_x2, _y2, _z2)
		var _v3 = new Vector3(_x3, _y3, _z3)
		
		// Calculate flat normals
		var _e1 = _v2.Subtract(_v1)
		var _e2 = _v3.Subtract(_v1)
		var _norm = _e1.Cross(_e2).Normalize().Negate();
		
		buffer_poke(_buffer, i + 12, buffer_f32, _norm.x);
        buffer_poke(_buffer, i + 16, buffer_f32, _norm.y);
        buffer_poke(_buffer, i + 20, buffer_f32, _norm.z);
        
        buffer_poke(_buffer, i + 48, buffer_f32, _norm.x);
        buffer_poke(_buffer, i + 52, buffer_f32, _norm.y);
        buffer_poke(_buffer, i + 56, buffer_f32, _norm.z);
        
        buffer_poke(_buffer, i + 84, buffer_f32, _norm.x);
        buffer_poke(_buffer, i + 88, buffer_f32, _norm.y);
        buffer_poke(_buffer, i + 92, buffer_f32, _norm.z);
		
		// Cache every vertex with the current normal
		var _v1_key = string("{0},{1},{2}", _x1, _y1, _z1)
		var _v2_key = string("{0},{1},{2}", _x2, _y2, _z2)
		var _v3_key = string("{0},{1},{2}", _x3, _y3, _z3)		
		
		// Creates a key in the cache. If key exists, add it
		if (!variable_struct_exists(_normal_cache, _v1_key)) {
			_normal_cache[$ _v1_key] = _norm
		} else {
			_normal_cache[$ _v1_key].Add(_norm)
		}
		
		if (!variable_struct_exists(_normal_cache, _v2_key)) {
			_normal_cache[$ _v2_key] = _norm
		} else {
			_normal_cache[$ _v2_key].Add(_norm)
		}
		
		if (!variable_struct_exists(_normal_cache, _v3_key)) {
			_normal_cache[$ _v3_key] = _norm
		} else {
			_normal_cache[$ _v3_key].Add(_norm)
		}
	}
	
	// Iterate again to calculate smooth normal based on the cache data
	for (var i = 0; i < buffer_get_size(_buffer); i += 36) {
		var _xx = buffer_peek(_buffer, i + 00, buffer_f32)
		var _yy = buffer_peek(_buffer, i + 04, buffer_f32)
		var _zz = buffer_peek(_buffer, i + 08, buffer_f32)
		var _nx = buffer_peek(_buffer, i + 12, buffer_f32);
        var _ny = buffer_peek(_buffer, i + 16, buffer_f32);
        var _nz = buffer_peek(_buffer, i + 20, buffer_f32);
		
		var _vertex_key = string("{0},{1},{2}", _xx, _yy, _zz)
		var _flat_normal = new Vector3(_nx, _ny, _nz);
		var _norm = _normal_cache[$ _vertex_key].Normalize()
			
		// Only apply smooth if the angle passes the treshold
		if (_flat_normal.Dot(_norm) > dcos(_threshold)) {
            buffer_poke(_buffer, i + 12, buffer_f32, _norm.x);
            buffer_poke(_buffer, i + 16, buffer_f32, _norm.y);
            buffer_poke(_buffer, i + 20, buffer_f32, _norm.z);
        }
	}
	
	var _vbo_calculated = vertex_create_buffer_from_buffer(_buffer, VFORMAT)	
	buffer_delete(_buffer)
	
	return _vbo_calculated;
}



