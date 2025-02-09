
init_inputs()

options[0] = [
	"Iniciar",
	"Opções",
	"Sair",
]

options[1] = [
	"Audio",
	"Video",
	"Voltar",
]

options[2] = [
	"Master",
	"Música",
	"Efeitos",
	"Voltar",
]

options[3] = [
	"Tela cheia",
	"Voltar",
]


menu_level = 0
selection = 0

op_sep = 26
op_x = GUI_WID*0.06
op_y = GUI_HEI*0.45
op_length = array_length(options[menu_level])
op_scl_base = 1
op_scl_spd = 0.1
op_hoffset = 0
op_col = 0
op_scl = 1


for (var i = 0; i < op_length; i++) {
	op_data[i] = [1, 1, 0, 0]
}

audio_set_master_gain(0, global.gamedata.audio[Volume.Master])
audio_group_set_gain(audio_music, global.gamedata.audio[Volume.Music], 0)
audio_group_set_gain(audio_sfx, global.gamedata.audio[Volume.Sfx], 0)