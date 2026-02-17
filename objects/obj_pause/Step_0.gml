if room == mainmenu || room == rank_room ||  room == rm_timesup || instance_exists(obj_technicaldifficulty) || (instance_exists(obj_shell) && obj_shell.isOpen)
	exit;

if instance_exists(obj_options)
{
	inputbuffer = 2
	exit;
}
else if inputbuffer > 0
{
	inputbuffer--
	exit;
}

// update input
update_input();

#region pause and unpausing

if ui_input.pause.pressed || (((optionselected == 0 && ui_input.accept.pressed) || ui_input.deny.pressed) && pause)
{
	if !pause
	{
		pause = true
		pause_image = make_pause_image()
		instance_deactivate_all(true)
		instance_activate_object(obj_pause_angel)
		instance_activate_object(obj_screensizer)
		instance_activate_object(obj_shakytext)
        instance_activate_object(obj_inputcontroller);
		if global.option_timerspeedrun
			instance_activate_object(obj_timer)
		audio_pause_all()
		var mu = scr_sound(mu_pause, true)
		audio_sound_gain(mu, 0, 0)
		audio_sound_gain(mu, 1, 1000)
		cursor.x = -60
		cursor.y = -300
		options = []
		for (var i = 0; i < array_length(baseoptions); i++) 
		{
			var cur_option = baseoptions[i]
			if (!global.in_level && cur_option.o_type == optiontypes.hub) 
			|| (global.in_level && cur_option.o_type == optiontypes.level)
			|| cur_option.o_type == optiontypes.both
				array_push(options, cur_option)
		}
	}
	else
		do_unpause()
}

#endregion



if !pause || room == mainmenu
	exit;

else if instance_exists(obj_shell)
{
	if obj_shell.isOpen
		exit;
}

if instance_exists(obj_options)
{
	inputbuffer = 2
	exit;
}
else if inputbuffer > 0
{
	inputbuffer--
	exit;
}

var movev = -ui_input.up.pressed + ui_input.down.pressed

if movev != 0
{
	var _p = 0.26
	scr_sound(sfx_step)
	scr_sound_pitched(sfx_ui_pausemove, 1 - _p, 1 + _p)
}

optionselected = wrap(array_length(options), optionselected + movev)

var cur_option = options[optionselected]

if ui_input.accept.pressed && cur_option.o_func != undefined
	cur_option.o_func()
	
if angel_timer > 0
	angel_timer--
else
{
	angel_timer = irandom_range(60, 480)
	instance_create(irandom_range(0, screen_w), screen_h - 100, obj_pause_angel)
}
