hl.config({
	general = {
		gaps_in = gaps_in,
		gaps_out = gaps_out,
		float_gaps = gaps_out,
		gaps_workspaces = gaps_in,
		border_size = borders,
		layout = layout,
		resize_on_border = true,
		no_focus_fallback = true,
		allow_tearing = true,
		["col.active_border"] = outline,
		["col.inactive_border"] = outline,
		["col.nogroup_border"] = secondary_container,
		["col.nogroup_border_active"] = secondary_container,
	},

	scrolling = {
		fullscreen_on_one_column = true,
		follow_focus = true,
		focus_fit_method = 1,
		explicit_column_widths = "0.33, 0.5, 0.66, 1.0",
		column_width = 0.5,
		direction = "right",
	},

	dwindle = {
		preserve_split = true,
		smart_split = false,
		smart_resizing = true,
		precise_mouse_move = false,
	},

	master = {
		mfact = 0.6,
		slave_count_for_center_master = 7,
		orientation = "left",
	},

	gestures = {
		workspace_swipe_distance = 700,
		workspace_swipe_cancel_ratio = 0.7,
		workspace_swipe_min_speed_to_force = 10,
		workspace_swipe_direction_lock = true,
		workspace_swipe_direction_lock_threshold = 10,
		workspace_swipe_create_new = true,
		gesture = {
			"3, " .. direction .. ", workspace",
			"4, vertical, dispatcher, scrolloverview:overview, toggle",
		},
	},

	group = {
		auto_group = true,
		drag_into_group = true,

		groupbar = {
			enabled = true,
			font_size = 16,
			keep_upper_gap = false,
			font_weight_active = 600,
			rounding = 8,
			indicator_height = 30,
			keep_upper_gap = true,
			stacked = false,
			render_titles = false,
			round_only_edges = true,
			blur = blur,
			["col.active"] = secondary_fixed_dim,
			["col.inactive"] = surface_dim,
			["text_color"] = on_secondary_fixed_variant,
		},
	},

	decoration = {
		rounding = rounding,
		rounding_power = rounding_power,
		border_part_of_window = true,
		dim_around = 0.45,
		shadow = {
			enabled = shadows,
			range = shadows_range,
			render_power = shadows_power,
			color = shadow,
		},
		blur = {
			enabled = blur,
			size = blur_size,
			passes = blur_passes,
			xray = xray,
			noise = 0, -- 0.125,
			ignore_opacity = ignore_opacity,
			new_optimizations = new_optimizations,
		},
	},

	input = {
		kb_layout = "us,eg",
		kb_options = "grp:caps_toggle",
		numlock_by_default = true,
		repeat_delay = 250,
		repeat_rate = 35,
		follow_mouse = 1,
		sensitivity = 0.105,
		force_no_accel = false,

		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
			clickfinger_behavior = true,
			scroll_factor = 0.5,
		},
	},

	render = {
		new_render_scheduling = true,
		cm_enabled = true,
		direct_scanout = 2,
		use_fp16 = 0,
		expand_undersized_textures = true,
		ctm_animation = true,
		cm_auto_hdr = true,
	},

	misc = {
		font_family = font_main,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		render_unfocused_fps = 4,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
		animate_manual_resizes = false,
		animate_mouse_windowdragging = false,
		enable_swallow = false,
		swallow_regex = "(foot|kitty|allacritty|Alacritty)",
		allow_session_lock_restore = true,
		initial_workspace_tracking = true,
		focus_on_activate = true,
	},

	binds = {
		scroll_event_delay = 0,
		hide_special_on_workspace_change = true,
	},

	cursor = {
		min_refresh_rate = 60,
		zoom_factor = 1,
		zoom_rigid = false,
		sync_gsettings_theme = true,
		no_hardware_cursors = false,
		inactive_timeout = 30,
		use_cpu_buffer = 2,
	},

	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
		enforce_permissions = false,
	},

	debug = {
		overlay = debug_overlay,
	},
})
